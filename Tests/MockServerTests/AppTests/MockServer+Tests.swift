import Foundation
import XCTest

@testable import MockServer

final class MockServerTests: XCTestCase {
  func testStartServerWithConfiguration() async {
    // Given
    let server = MockServer()
    
    // When
    let configuration = Configuration(networkExchanges: [])
    
    // Then
    XCTAssertNoThrow(try server.start(using: configuration))
    XCTAssertEqual(server.host, configuration.hostname)
    XCTAssertEqual(server.port, configuration.port)
    
    try? await server.stop()
  }
  
  func testStartThrowsWhenInstanceAlreadyRunning() {
    defer {
      Task {
        try? await server.stop()
      }
    }
    
    // Given
    let server = MockServer()
    let configuration = Configuration(networkExchanges: [])
    
    // When
    try? server.start(using: configuration)
    
    // Then
    XCTAssertThrowsError(try server.start(using: configuration)) { error in
      guard case .instanceAlreadyRunning = error as? MockServer.Error else {
        XCTFail("Was expecting MockServer.Error.instanceAlreadyRunning but got \(error) instead")
        
        return
      }
      
      XCTAssertTrue(true)
    }
  }
}

extension MockServerTests {
  struct Configuration: ServerConfigurationProvider {
    var networkExchanges: [MockServer.NetworkExchange]
    var environment: MockServer.Environment = .testing
  }
}
