import XCTest

@testable import EMMockServer

final class MockServerTests: XCTestCase {
  func test_configuration_work() {
    // Given
    let mockServer = MockServer()
    
    // Then
    XCTAssertNoThrow(try mockServer.configure(using: TestsHelpers.DefaultConfiguration(networkExchanges: [])))
    XCTAssertEqual(mockServer.host, "127.0.0.1")
    XCTAssertEqual(mockServer.port, 8080)

    // Given
    var castedErrorCorrectly: Bool = false
    
    // When
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
}
