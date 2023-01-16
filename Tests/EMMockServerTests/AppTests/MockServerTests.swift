import XCTVapor

@testable import EMMockServer

final class MockServerTests: XCTestCase {
  func test_configuration_work() {
    // Given
    let mockServer = MockServer()
    
    // Then
    XCTAssertNoThrow(try mockServer.configure(using: TestsHelpers.DefaultConfiguration(networkExchanges: [])))
    XCTAssertEqual(mockServer.host, "127.0.0.1")
    XCTAssertEqual(mockServer.port, 8080)
    XCTAssertEqual(mockServer.delay, 0)
    
    // Given
    var castedErrorCorrectly: Bool = false
    
    // Then
    XCTAssertThrowsError(
      try mockServer.configure(using: TestsHelpers.DefaultConfiguration(networkExchanges: []))
    ) { error in
      guard case .instanceAlreadyRunning = error as? MockServer.Error else {
        XCTFail("Was expecting a `.instanceAlreadyRunning` error but got `\(error) instead")
        return
      }
      
      castedErrorCorrectly = true
    }
    
    XCTAssertTrue(castedErrorCorrectly)
  }
  
  func test_delay_properly_executes() throws {
    // Given
    let app = Application(.testing)
    defer { app.shutdown() }
    let mockServer = MockServer()
    let exchange = MockServer.NetworkExchange(
      request: MockServer.Request(method: .GET, path: ["string"]),
      response: MockServer.Response(status: .created)
    )
    try mockServer.configure(using: TestsHelpers.Configuration(networkExchanges: [exchange], delay: 2))
    mockServer.registerRoutes([exchange], to: app)
    
    // When
    let startTime = CFAbsoluteTimeGetCurrent()
    var timeElapsed: CFAbsoluteTime!
    
    try app.test(.GET, "string") { response in
      timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
    }
    
    // Then
    XCTAssertTrue((1.5...2.5) ~= timeElapsed) // We give it a 0.5s tolerance
  }
}
