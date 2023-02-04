import Foundation
import Vapor

extension MockServer {
  /// An object that represents an `HTTP` request.
  /// The request is composed of:
  /// - an `HTTPMethod`
  /// - a path that the request responds to.
  public struct Request {
    /// The `HTTPMethod` of the request.
    public let method: HTTPMethod
    
    /// The `Path` associated with `Request`.
    /// Include `*` in any position and the value of that field will be discarded. This is useful when the path includes an `ID`.
    /// Include `**` and any string at this position or later positions will be matched in the request.
    ///
    /// - Note:
    /// - `/api/v1/users` will be matched by `/api/v1/users`.
    ///
    /// - `/api/*/users` will be matched by `/api/v1/users`, `/api/v2/users` and anything similar.
    ///
    /// - `/api/**` will be matched by `/api/v1/users`, `/api/users/notes` and anything that starts with `/api`.
    public let path: Path
    
    /// Returns the path as a `String` where each component is separated by a slash.
    public var pathAsString: String {
      path.reduce(into: "") {
        $0 += "/\($1)"
      }
    }
    
    /// ``path`` transformed into Vapor's [PathComponent]
    internal var pathComponents: [PathComponent] {
      path.map {
        PathComponent(stringLiteral: $0)
      }
    }
    
    /// Returns a `Request` object.
    /// - Parameters:
    ///   - method: The `HTTPMethod` of the request.
    ///   - path: The `Path` associated with `Request`.
    public init(
      method: HTTPMethod,
      path: Path
    ) {
      self.method = method
      self.path = path
    }
  }
}
