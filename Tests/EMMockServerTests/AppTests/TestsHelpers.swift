import Foundation

@testable import EMMockServer

enum TestsHelpers {
  
  // MARK: Properties
  
  static var networkExchanges: [MockServer.NetworkExchange] {
    [
      MockServer.NetworkExchange(
        request: MockServer.Request(method: .GET, path: ["json"]),
        response: MockServer.Response(
          kind: .json(Person(name: "Jason"))
        )
      ),
      MockServer.NetworkExchange(
        request: MockServer.Request(method: .POST, path: ["data"]),
        response: MockServer.Response(
          headers: ["Content-Type": "application/json"],
          kind: .data(try! JSONEncoder().encode(Person(name: "Data")))
        )
      ),
      MockServer.NetworkExchange(
        request: MockServer.Request(method: .PATCH, path: ["string"]),
        response: MockServer.Response(
          status: .internalServerError,
          headers: ["someKey": "someValue"],
          kind: .string("Something went wrong")
        )
      ),
      MockServer.NetworkExchange(
        request: MockServer.Request(method: .POST, path: ["empty"]),
        response: MockServer.Response(
          status: .created,
          kind: .empty
        )
      ),
      MockServer.NetworkExchange(
        request: MockServer.Request(method: .GET, path: ["file"]),
        response: MockServer.Response(
          kind: .fileContent(pathToFile: Bundle.module.path(forResource: "Resources/file", ofType: "json")!)
        )
      )
    ]
  }
  
  // MARK: Configuration
  
  struct DefaultConfiguration: ServerConfigurationProvider {
    var networkExchanges: [MockServer.NetworkExchange]
  }
  
  struct Configuration: ServerConfigurationProvider {
    var networkExchanges: [MockServer.NetworkExchange]
    let environment: MockServer.Environment = .testing
    var hostname: String = "localhost"
    var port: Int = 8081
  }
  
  // MARK: Objects
  
  struct Person: Encodable {
    let name: String
  }
}
