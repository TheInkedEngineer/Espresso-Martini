import Foundation

extension URL {
  /// Returns an `HTTPMethod` from the last path component.
  public var httpMethod: HTTPMethod {
    HTTPMethod(rawValue: lastPathComponent.uppercased())
  }
  
  /// Validates that a path represent a directory, and the name of that latter is a valid HTTPMethod different from `RAW`.
  public var hasMethodPath: Bool {
    guard hasDirectoryPath else {
      return false
    }
    
    if case .RAW = httpMethod {
      return false
    }
    
    return true
  }
  
  /// Helper that calls the appropriate method based on the iOS and macOS versions.
  public func appending(_ path: String) -> Self {
    if #available(macOS 13.0, *), #available(iOS 16.0, *) {
      return appending(path: path)
    } else {
      return appendingPathComponent(path)
    }
  }
}
