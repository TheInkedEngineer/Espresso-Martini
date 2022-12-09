import MockServer
import Vapor

let server = MockServer()
try? server.configure(using: ServerConfiguration())
try? server.start()

defer {
  Task {
    try? await server.stop()
  }
}


struct ServerConfiguration: ServerConfigurationProvider {
  var networkExchanges: [MockServer.NetworkExchange] = [
    MockServer.NetworkExchange(
      request: MockServer.Request(method: .GET, path: ["json"]),
      response: MockServer.Response(
        kind: .json(Person(name: "Jason"))
      )
    ),
    
    MockServer.NetworkExchange(
      request: MockServer.Request(method: .GET, path: ["data"]),
      response: MockServer.Response(
        headers: ["Content-Type": "application/json"],
        kind: .data(try! JSONEncoder().encode(Person(name: "Data")))
      )
    ),
    
    MockServer.NetworkExchange(
      request: MockServer.Request(method: .GET, path: ["string"]),
      response: MockServer.Response(
        kind: .string("String")
      )
    ),
    
    MockServer.NetworkExchange(
      request: MockServer.Request(method: .GET, path: ["file"]),
      response: MockServer.Response(
        kind: .fileContent(pathToFile: Bundle.module.path(forResource: "Resources/file", ofType: "json")!)
      )
    ),
    MockServer.NetworkExchange(
      request: MockServer.Request(method: .GET, path: ["image"]),
      response: MockServer.Response(
        kind: .fileContent(pathToFile: Bundle.module.path(forResource: "Resources/vapor", ofType: "jpg")!)
      )
    )
  ]
  
  var environment: MockServer.Environment = .development
  
  let hostname: String = "127.0.0.1"
  let port: Int = 8080
}

struct Person: Encodable {
  let name: String
}
