import Foundation

/// An concrete implementation of `ServerConfigurationProvider`.
public struct MockServerConfiguration: ServerConfigurationProvider {
  public let networkExchanges: [EMMockServer.MockServer.NetworkExchange]
  public let environment: MockServer.Environment
  public let hostname: String
  public let port: Int
  public let delay: TimeInterval
  
  public init(
    networkExchanges: [EMMockServer.MockServer.NetworkExchange],
    environment: MockServer.Environment,
    hostname: String,
    port: Int,
    delay: TimeInterval
  ) {
    self.networkExchanges = networkExchanges
    self.environment = environment
    self.hostname = hostname
    self.port = port
    self.delay = delay
  }
}


/// A simple implementation of `ServerConfigurationProvider` that uses all the default values.
public struct MockServerSimpleConfiguration: ServerConfigurationProvider {
  public let networkExchanges: [EMMockServer.MockServer.NetworkExchange]
  
  public init(networkExchanges: [EMMockServer.MockServer.NetworkExchange]) {
    self.networkExchanges = networkExchanges
  }
}

/// A simple implementation of `ServerConfigurationProvider` that uses all the default values.
@available(*, deprecated, renamed: "MockServerSimpleConfiguration")
public struct SimpleConfigurationProvider: ServerConfigurationProvider {
  public let networkExchanges: [EMMockServer.MockServer.NetworkExchange]
  
  public init(networkExchanges: [EMMockServer.MockServer.NetworkExchange]) {
    self.networkExchanges = networkExchanges
  }
}
