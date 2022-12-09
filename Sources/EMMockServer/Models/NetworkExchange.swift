import Foundation

extension MockServer {
  /// An object representing a network exchange made of a `MockServer.Request` and `MockServer.Response`.
  public struct NetworkExchange {
    /// A `MockServer.Request` object.
    let request: Request
    
    /// A `MockServer.Response` object.
    let response: Response
    
    public init(request: MockServer.Request, response: MockServer.Response) {
      self.request = request
      self.response = response
    }
  }
}
