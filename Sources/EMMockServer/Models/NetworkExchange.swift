import Foundation

extension MockServer {
  /// An object representing a network exchange made of a `MockServer.Request` and `MockServer.Response`.
  public struct NetworkExchange {
    /// A `MockServer.Request` object.
    public let request: Request
    
    /// A `MockServer.Response` object.
    public let response: [Response]
    
    /// The delay to apply between the request and the returned response.
    ///
    /// If this value is nil, the value inside ``ServerConfigurationProvider`` is used.
    /// If this value is set, it overrides the value of the delay inside the server configuration.
    @available(
      *,
      unavailable,
      message: """
        This value is no longer needed. It has been moved inside of `MockServer.Response`.
        The original initialiser won't be affected" as it injects it from this level to the `MockServer.Response.delay`.
        """
    )
    public let delay: TimeInterval? = nil
    
    /// Creates a `NetworkExchange` object.
    /// - Parameters:
    ///   - request: A `MockServer.Request` object.
    ///   - response: A `MockServer.Response` object.
    ///   - delay: The delay to apply between the request and the returned response.
    public init(request: MockServer.Request, response: MockServer.Response, delay: TimeInterval? = nil) {
      let response = MockServer.Response(
        status: response.status,
        headers: response.headers,
        kind: response.kind,
        delay: delay
      )
      
      self.init(request: request, response: [response])
    }
    
    /// Creates a `NetworkExchange` object.
    /// - Parameters:
    ///   - request: A `MockServer.Request` object.
    ///   - response: An array of `MockServer.Response` object.
    ///   - delay: The delay to apply between the request and the returned response.
    public init(request: MockServer.Request, response: [MockServer.Response]) {
      self.request = request
      self.response = response
    }
  }
}
