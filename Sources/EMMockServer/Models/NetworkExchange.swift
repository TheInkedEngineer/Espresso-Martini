import Foundation

extension MockServer {
  /// An object representing a network exchange made of a `MockServer.Request` and `MockServer.Response`.
  public struct NetworkExchange {
    /// A `MockServer.Request` object.
    let request: Request
    
    /// A `MockServer.Response` object.
    let response: Response
    
    /// The delay to apply between the request and the returned response.
    ///
    /// If this value is nil, the value inside ``ServerConfigurationProvider`` is used.
    /// If this value is set, it overrides the value of the delay inside the server configuration.
    let delay: TimeInterval?
    
    /// Creates a `NetworkExchange` object.
    /// - Parameters:
    ///   - request: A `MockServer.Request` object.
    ///   - response: A `MockServer.Response` object.
    ///   - delay: The delay to apply between the request and the returned response.
    public init(request: MockServer.Request, response: MockServer.Response, delay: TimeInterval? = nil) {
      self.request = request
      self.response = response
      self.delay = delay
    }
  }
}
