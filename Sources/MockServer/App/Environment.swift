import Foundation
import Vapor

extension MockServer {
  /// The environment the application is running in, i.e., production, development.
  public enum Environment {
    case custom(name: String)
    case development
    case production
    case testing
    
    /// The `Vapor` environment in which to run the server.
    internal var vaporEnvironment: Vapor.Environment {
      switch self {
        case .development:
          return .development
          
        case .production:
          return .production
          
        case .testing:
          return .testing
          
        case let .custom(name):
          return .custom(name: name)
      }
    }
  }
}
