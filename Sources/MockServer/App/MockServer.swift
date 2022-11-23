import Foundation
import Vapor

/// An object that can mock the behavior of a network exchange.
public class MockServer {
  
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
  
  public init() {}
  
  // MARK: Methods
  
  public func start(using configuration: ServerConfigurationProvider) throws {
    guard vaporApplication == nil else {
      throw Error.instanceAlreadyRunning
    }
   
    vaporApplication = Application(configuration.environment.vaporEnvironment)
    vaporApplication?.http.server.configuration.port = configuration.port
    vaporApplication?.http.server.configuration.hostname = configuration.hostname
  
    do {
      registerRoutes(for: configuration.networkExchanges)
      try vaporApplication?.run()
    } catch {
      print(error)
      // The most common error would be when we try to run the server on a PORT that is already used.
//      throw Error.vapor(error: error)
    }
  }
  
  /// Shuts down the currently running instance of `Vapor`'s application, if any.
  public func stop() throws {
    vaporApplication?.server.shutdown()
    #warning("Check if this is the way to do it, or is there an async wait")
    try vaporApplication?.server.onShutdown.wait()
    vaporApplication = nil
  }
  
  /// Shuts down the currently running instance of `Application` if any,
  /// then starts a new `Application` instance using the passed configuration.
  /// - Parameter configuration: An object conforming to `ServerConfigurationProvider`.
  /// - Throws: `ServerError.instanceAlreadyRunning` or a wrapped `Vapor` error.
  public func restart(with configuration: ServerConfigurationProvider) throws {
    try stop()
    try start(using: configuration)
  }
  
  /// Registers the route
  private func registerRoutes(for networkExchanges: [NetworkExchange]) {
    networkExchanges.forEach { networkExchange in
      vaporApplication?
        .on(networkExchange.request.method, networkExchange.request.pathComponents) { [networkExchange] request async throws in
          let byteBuffer: ByteBuffer? = await {
            switch networkExchange.response.kind {
              case .empty:
                return nil
                
              case let .string(value):
                return ByteBuffer(string: value)
                
              case let .data(value):
                return ByteBuffer(data: value)
                
              case let .json(value, encoder):
                guard let data = try? encoder.encode(value) else {
                  return nil
                }
                
                return ByteBuffer(data: data)
                
              case let .fileContent(pathToFile):
                return try? await request.fileio.collectFile(at: pathToFile).get()
            }
          }()
          
          let clientResponse = ClientResponse(
            status: networkExchange.response.status,
            headers: networkExchange.response.headers,
            body: byteBuffer
          )
          
          return clientResponse
      }
    }
  }
}
