import Foundation

extension MockServer {
  /// The possible errors that the `MockServer` can run into.
  enum Error: Swift.Error {
    /// An instance of the server is already up and running.
    ///
    /// If you wish to start a new instance make sure to stop all running instances.
    case instanceAlreadyRunning
    
    /// The `MockServer` was ran before calling `configure(configuration:)`.
    case serverNotConfigured
    
    /// An error thrown by vapor.
    case vapor(error: Swift.Error)
  }
}
