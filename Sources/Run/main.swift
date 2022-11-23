import MockServer
import Vapor

let server = MockServer()
try? server.start(using: ServerConfiguration())

defer { try? server.stop() }


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
    )
  ]
  
  var environment: MockServer.Environment = .development
  
  let hostname: String = "127.0.0.1"
  let port: Int = 8080
}

struct Person: Encodable {
  let name: String
}
