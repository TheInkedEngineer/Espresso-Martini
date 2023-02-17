import EMLogger
import Foundation

extension MockServer {
  /// An concrete implementation of `ServerConfigurationProvider`.
  public struct Configuration: ServerConfigurationProvider {
    public let networkExchanges: [EMMockServer.MockServer.NetworkExchange]
    public let environment: MockServer.Environment
    public let hostname: String
    public let port: Int
    public let delay: TimeInterval
    public let logLevel: EMLogger.Level
    
    public init(
      networkExchanges: [EMMockServer.MockServer.NetworkExchange],
      environment: MockServer.Environment,
      hostname: String,
      port: Int,
      delay: TimeInterval,
      logLevel: EMLogger.Level
    ) {
      self.networkExchanges = networkExchanges
      self.environment = environment
      self.hostname = hostname
      self.port = port
      self.delay = delay
      self.logLevel = logLevel
    }
  }
  
  /// A simple implementation of `ServerConfigurationProvider` that uses all the default values.
  public struct SimpleConfiguration: ServerConfigurationProvider {
    public let networkExchanges: [EMMockServer.MockServer.NetworkExchange]
    
    public init(networkExchanges: [EMMockServer.MockServer.NetworkExchange]) {
      self.networkExchanges = networkExchanges
    }
  }
}

/// A simple implementation of `ServerConfigurationProvider` that uses all the default values.
@available(*, deprecated, renamed: "MockServer.SimpleConfiguration")
public struct SimpleConfigurationProvider: ServerConfigurationProvider {
  public let networkExchanges: [EMMockServer.MockServer.NetworkExchange]
  
  public init(networkExchanges: [EMMockServer.MockServer.NetworkExchange]) {
    self.networkExchanges = networkExchanges
  }
}
