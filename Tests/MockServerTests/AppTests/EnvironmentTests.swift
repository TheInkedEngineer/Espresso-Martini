import Foundation
import Vapor
import XCTest

@testable import MockServer

final class EnvironmentTests: XCTestCase {
  func testVaporValue() {
    XCTAssertEqual(MockServer.Environment.development.vaporEnvironment, Vapor.Environment.development)
    XCTAssertEqual(MockServer.Environment.testing.vaporEnvironment, Vapor.Environment.testing)
    XCTAssertEqual(MockServer.Environment.custom(name: "customEnv").vaporEnvironment, Vapor.Environment.custom(name: "customEnv"))
  }
}
