import Foundation
import Vapor

public struct Server {
  
  // MARK: Properties
  
  /// The `Vapor` `Application` instance.
  private var vaporApplication: Application?
  
  /// The host associated with the running instance's configuration.
  internal var host: String? {
    vaporApplication?.http.server.configuration.hostname
  }

  /// The port associated with the running instance's configuration.
  internal var port: Int? {
    vaporApplication?.http.server.configuration.port
  }
  
  // MARK: Init
  
  public init(using configuration: ServerConfigurationProvider) {
    
  }
  
  // MARK: Methods
}
