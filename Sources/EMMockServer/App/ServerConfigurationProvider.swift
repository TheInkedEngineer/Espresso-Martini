import Foundation
import EMLogger

/// The required configuration for the server to properly run.
public protocol ServerConfigurationProvider {
  /// The list of all network exchanges the server should be able to intercept and return.
  var networkExchanges: [MockServer.NetworkExchange] { get }
  
  /// The environment in which to run the application.
  ///
  /// Defaults to `.development`.
  var environment: MockServer.Environment { get }
  
  /// The host part of the `URL`.
  ///
  /// Defaults to `127.0.0.1`.
  var hostname: String { get }

  /// The port listening to incoming requests.
  ///
  /// Defaults to `8080`.
  var port: Int { get }
  
  /// The amount of time (in seconds) the server has to wait before before returning the response.
  ///
  /// Defaults to `0`.
  var delay: TimeInterval { get }
  
  /// The desired level of logging.
  var logLevel: EMLogger.Level { get }
}

extension ServerConfigurationProvider {
  public var environment: MockServer.Environment {
    .development
  }
  
  public var hostname: String {
    "127.0.0.1"
  }
  
  public var port: Int {
    8080
  }
  
  public var delay: TimeInterval {
    0
  }
  
  public var logLevel: EMLogger.Level {
    .info
  }
}
