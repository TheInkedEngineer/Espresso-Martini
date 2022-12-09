import Foundation
import Vapor

/// An object that can mock the behavior of a network exchange.
/// It consists of 2 main methods:
///  - `configure(configuration:)` which instantiates the `Vapor` application and register the routes.
///  - `start()` which runs the `Vapor` instance.
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
  
  /// Configures the `MockServer` instance.
  ///
  /// This needs to be called before the `start()` method is called.
  /// - Parameter configuration: An object conforming to `ServerConfigurationProvider`, providing the necessary information.
  public func configure(using configuration: any ServerConfigurationProvider) throws {
    guard vaporApplication == nil else {
      throw Error.instanceAlreadyRunning
    }
   
    vaporApplication = Application(configuration.environment.vaporEnvironment)
    vaporApplication?.http.server.configuration.port = configuration.port
    vaporApplication?.http.server.configuration.hostname = configuration.hostname
    
    registerRoutes(configuration.networkExchanges, to: vaporApplication!)
  }
  
  /// Starts the underlying `Vapor` instance of the `MockServer`.
  public func start() throws {
    guard let vaporApplication else {
      throw Error.serverNotConfigured
    }
    
    do {
      try vaporApplication.run()
    } catch {
      // The most common error would be when we try to run the server on a PORT that is already used.
      throw Error.vapor(error: error)
    }
  }
  
  /// Shuts down the currently running instance of `Vapor`'s application, if any.
  public func stop() async throws {
    vaporApplication?.server.shutdown()
    try await vaporApplication?.server.onShutdown.get()
    vaporApplication = nil
  }
  
  /// Shuts down the currently running instance of `Application` if any,
  /// then starts a new `Application` instance using the passed configuration.
  /// - Parameter configuration: An object conforming to `ServerConfigurationProvider`.
  /// - Throws: `ServerError.instanceAlreadyRunning` or a wrapped `Vapor` error.
  public func restart(with configuration: ServerConfigurationProvider) async throws {
    try await stop()
    try configure(using: configuration)
    try start()
  }
  
  /// Registers the routes that the Mock server should be able to intercept and respond to.
  /// - Parameters:
  ///   - networkExchanges: An array of ``NetworkExchange`` to build the routes to intercept.
  ///   - application: The `Vapor` application instance to which we attach the routes.
  internal func registerRoutes(_ networkExchanges: [NetworkExchange], to application: Application) {
    networkExchanges.forEach { networkExchange in
      application
        .on(networkExchange.request.method, networkExchange.request.pathComponents) { [networkExchange] request async throws in
          // The bytes to return with the response.
          let byteBuffer: ByteBuffer?
          
          switch networkExchange.response.kind {
            case .empty:
              byteBuffer = nil
              
            case let .string(value):
              byteBuffer = ByteBuffer(string: value)
              
            case let .data(value):
              byteBuffer = ByteBuffer(data: value)
              
            case let .json(value, encoder):
              guard let data = try? encoder.encode(value) else {
                // If we fail to encode the data, we just throw a server error.
                return ClientResponse(
                  status: .internalServerError,
                  headers: networkExchange.response.headers.removing(name: "Content-Type"),
                  body: nil
                )
              }
              
              byteBuffer = ByteBuffer(data: data)
              
            case let .fileContent(pathToFile):
              // If we fail to find the file (most likely only reason for failure), we just throw a 404 error.
              guard let content = try? await request.fileio.collectFile(at: pathToFile).get() else {
                return ClientResponse(
                  status: .notFound,
                  headers: networkExchange.response.headers.removing(name: "Content-Type"),
                  body: nil
                )
              }
              
              byteBuffer = content
          }
          
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
