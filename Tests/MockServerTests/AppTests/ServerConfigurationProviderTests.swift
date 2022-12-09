import Foundation
import XCTest

@testable import MockServer

final class ServerConfigurationProviderTests: XCTestCase {
  func testDefaultValuesProperlySet() {
    // Given
    let configuration = TestsHelpers.DefaultConfiguration(networkExchanges: [])
    
    // Then
    XCTAssertEqual(configuration.environment, .development)
    XCTAssertEqual(configuration.hostname, "127.0.0.1")
    XCTAssertEqual(configuration.port, 8080)
  }
  
  func testCustomValuesProperlySet() {
    // Given
    let configuration = TestsHelpers.Configuration(networkExchanges: [])
    
    // Then
    XCTAssertEqual(configuration.environment, .testing)
    XCTAssertEqual(configuration.hostname, "localhost")
    XCTAssertEqual(configuration.port, 8081)
  }
}
