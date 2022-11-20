import XCTest
import Vapor

@testable import Server

final class HTTPHeadersExtensionsTests: XCTestCase {
  func test_removingHeader() {
    // Given
    let headers = HTTPHeaders([("headerOne", "valueOne"), ("headerTwo", "valueTwo")])
    let expectedResult = HTTPHeaders([("headerTwo", ("valueTwo"))])
                 
    // When
    let subject = headers.removing(name: "headerOne")
    
    // Then
    XCTAssertEqual(subject, expectedResult)
  }
  
  func test_replacingOrAdding_addsMissingValue() {
    // Given
    let headers = HTTPHeaders([("headerOne", "valueOne")])
    let expectedResult = HTTPHeaders([("headerOne", "valueOne"), ("headerTwo", "valueTwo")])
    
    // When
    let subject = headers.replacingOrAdding(name: "headerTwo", value: "valueTwo")
    
    // Then
    XCTAssertEqual(subject, expectedResult)
  }
  
  func test_replacingOrAdding_replacesExistingValue() {
    // Given
    let headers = HTTPHeaders([("headerOne", "valueOne"), ("headerTwo", "wrongValue")])
    let expectedResult = HTTPHeaders([("headerOne", "valueOne"), ("headerTwo", "valueTwo")])
    
    // When
    let subject = headers.replacingOrAdding(name: "headerTwo", value: "valueTwo")
    
    // Then
    XCTAssertEqual(subject, expectedResult)
  }
}
