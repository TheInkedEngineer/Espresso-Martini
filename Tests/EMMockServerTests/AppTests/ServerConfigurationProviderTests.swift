import Foundation
import XCTest

@testable import EMMockServer

final class ServerConfigurationProviderTests: XCTestCase {
  func testDefaultValuesProperlySet() {
    // Given
    let configuration = TestsHelpers.DefaultConfiguration(networkExchanges: [])
    
    // Then
    XCTAssertEqual(configuration.environment, .development)
    XCTAssertEqual(configuration.hostname, "127.0.0.1")
    XCTAssertEqual(configuration.port, 8080)
    XCTAssertEqual(configuration.delay, 0)
  }
  
  func testCustomValuesProperlySet() {
    // Given
    let configuration = TestsHelpers.Configuration(networkExchanges: [])
    
    // Then
    XCTAssertEqual(configuration.environment, .testing)
    XCTAssertEqual(configuration.hostname, "localhost")
    XCTAssertEqual(configuration.port, 8081)
    XCTAssertEqual(configuration.delay, 0.1)
  }
}
