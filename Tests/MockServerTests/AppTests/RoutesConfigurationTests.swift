import XCTVapor
@testable import MockServer

final class RoutesConfigurationTests: XCTestCase {
  func test_routes_correctly_configured() throws {
    // Given
    let app = Application(.testing)
    defer { app.shutdown() }
    
    // When
    MockServer().registerRoutes(TestsHelpers.networkExchanges, to: app)
    
    // Then
    try app.test(.GET, "json", afterResponse: { res in
      XCTAssertEqual(res.status, .ok)
      XCTAssertEqual(res.headers.contentType, HTTPMediaType.json)
      XCTAssertEqual(res.body.string, "{\"name\":\"Jason\"}")
    })
    
    try app.test(.POST, "data", afterResponse: { res in
      XCTAssertEqual(res.status, .ok)
      XCTAssertEqual(res.headers.contentType, HTTPMediaType.json)
      XCTAssertEqual(res.body.string, "{\"name\":\"Data\"}")
    })
    
    try app.test(.PATCH, "string", afterResponse: { res in
      XCTAssertEqual(res.status, .internalServerError)
      XCTAssertTrue(res.headers.contains(name: "someKey"))
      XCTAssertEqual(res.body.string, "Something went wrong")
    })
    
    try app.test(.POST, "empty", afterResponse: { res in
      XCTAssertEqual(res.status, .created)
      XCTAssertEqual(res.body.string, "")
    })
    
    try app.test(.GET, "file", afterResponse: { res in
      XCTAssertEqual(res.status, .ok)
      XCTAssertEqual(
        res.body.string,
        """
        {
          "name": "file"
        }
        
        """
      )
    })
  }
  
  func test_failedToEncode_returns_serverError() throws {
    struct Event: Encodable {
      let name: String
      
      func encode(to encoder: Encoder) throws {
        // We just want to throw to force an encoding error. It does not matter what that is.
        throw MockServer.Error.serverNotConfigured
      }
    }
    
    // Given
    let app = Application(.testing)
    defer { app.shutdown() }
    
    MockServer().registerRoutes(
      [
        MockServer.NetworkExchange(
          request: MockServer.Request(method: .GET, path: ["json"]),
          response: MockServer.Response(
            kind: .json(Event(name: "Event"))
          )
        )
      ],
      to: app
    )
    
    // Then
    try app.test(.GET, "json", afterResponse: { res in
      XCTAssertEqual(res.status, .internalServerError)
      XCTAssertEqual(res.body.string, "")
    })
  }

  func test_missingFile_returns_404() throws {
    // Given
    let app = Application(.testing)
    defer { app.shutdown() }
    
    MockServer().registerRoutes(
      [
        MockServer.NetworkExchange(
          request: MockServer.Request(method: .GET, path: ["file"]),
          response: MockServer.Response(
            kind: .fileContent(pathToFile: "no-path")
          )
        )
      ],
      to: app
    )
    
    // Then
    try app.test(.GET, "file", afterResponse: { res in
      XCTAssertEqual(res.status, .notFound)
      XCTAssertEqual(res.body.string, "")
    })
  }
}
