import Foundation

/// The required configuration for the server to properly run.
public protocol ServerConfigurationProvider {
  /// The list of all network exchanges the server should be able to intercept and return.
  var networkExchanges: [MockServer.NetworkExchange] { get }
  
  /// The environment in which to run the application.
  var environment: MockServer.Environment { get }
  
  /// The host part of the `URL`.
  var hostname: String { get }

  /// The port listening to incoming requests.
  var port: Int { get }
}
