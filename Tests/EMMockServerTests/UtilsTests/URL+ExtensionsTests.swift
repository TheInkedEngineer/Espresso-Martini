import Foundation
import XCTest

@testable import EMMockServer

final class URLExtensionsTests: XCTestCase {
  func test_httpMethod_correctlyReturned_from_url() {
    let url = URL(string: "some/path/to/GET")
    XCTAssertEqual(url?.httpMethod, .GET)
    
    let invalidMethod = URL(string: "some/path/to/gibberish")
    XCTAssertEqual(invalidMethod?.httpMethod, .RAW(value: "GIBBERISH"))
  }
  
  func test_hasMethodPath_returns_true() {
    let url = URL(string: "some/path/to/GET/")!
    XCTAssertTrue(url.hasMethodPath)
  }
  
  func test_hasMethodPath_returns_false() {
    let url = URL(string: "some/path/to/random/")!
    XCTAssertFalse(url.hasMethodPath)
    
    let file = URL(string: "some/path/to/file.json")!
    XCTAssertFalse(file.hasMethodPath)
  }
  
  func test_appending_correctly_appends() {
    let url = URL(string: "some/path")!.appending("file.json")
    XCTAssertEqual(url, URL(string: "some/path/file.json"))
  }
}
