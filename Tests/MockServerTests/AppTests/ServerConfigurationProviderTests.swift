import Foundation
import XCTest

@testable import MockServer

final class ServerConfigurationProviderTests: XCTestCase {
  func testDefaultValuesProperlySet() {
    // Given
    let configuration = DefaultConfiguration(networkExchanges: [])
    
    // Then
    XCTAssertEqual(configuration.environment, .development)
    XCTAssertEqual(configuration.hostname, "127.0.0.1")
    XCTAssertEqual(configuration.port, 8080)
  }
}

extension ServerConfigurationProviderTests {
  struct DefaultConfiguration: ServerConfigurationProvider {
    var networkExchanges: [MockServer.NetworkExchange]
  }
}
