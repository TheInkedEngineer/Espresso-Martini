import Foundation
import Vapor

extension MockServer {
  /// An object associated with the `Request` reflecting the desired `Response` by the user.
  public struct Response {
    /// The HTTP response status.
    public let status: HTTPResponseStatus
    
    /// The header fields for this HTTP response.
    ///
    /// The `"Content-Length"` and `"Transfer-Encoding"` headers will be set automatically when the `body` property is mutated.
    public let headers: HTTPHeaders
    
    /// The desired kind of response.
    ///
    /// The kind or file extension will automatically set the value for `Content-Type` in the headers, and will override any passed value in the headers section.
    /// Whenever the status code does not support a body, like `HTTPResponseStatus.noContent`, This `kind` will be set to `empty`.
    public let kind: Kind

    
    /// Returns an instance of `RequestedResponse`
    /// - Parameters:
    ///   - status: The HTTP response status. Defaults to `.ok`.
    ///   - headers: The header fields for this HTTP response.
    ///   - kind: The kind of response to expect. Defaults to `.empty`.
    public init(
      status: HTTPResponseStatus = .ok,
      headers: HTTPHeaders = [:],
      kind: Kind = .empty
    ) {
      self.status = status
      self.kind = status.mayHaveResponseBody ? kind : .empty
      
      switch kind {
        case let .fileContent(pathToFile):
          if
            let fileExtension = pathToFile.split(separator: ".").last,
            let contentType = HTTPMediaType.fileExtension(String(fileExtension))?.serialize()
          {
            // We override the `Content-Type` to align it with the data being sent.
            self.headers = headers.replacingOrAdding(name: "Content-Type", value: contentType)
          } else {
            // If the file path is corrupt, then `Content-Type` should not exist.
            self.headers = headers.removing(name: "Content-Type")
          }
          
        case .json:
          self.headers = headers.replacingOrAdding(name: "Content-Type", value: "application/json")
          
        case .string:
          self.headers = headers.replacingOrAdding(name: "Content-Type", value: "text/plain")
          
        case .empty, .data:
          self.headers = headers
      }
    }
  }
}

extension MockServer.Response {
  public enum Kind {
    /// An empty response.
    ///
    /// Suitable for HTTP requests with no responses, like `HTTPResponseStatus.noContent`
    case empty

    /// The response is some Data.
    ///
    /// The `Content-Type` header should be set manually.
    case data(_ data: Data)

    /// A simple string.
    case string(_ value: String)

    /// An encodable `JSON` data.
    ///
    /// Will automatically set (or override) the `Content-Type`.
    case json(_ value: Encodable, encoder: JSONEncoder = JSONEncoder())

    /// Data to read off a file.
    ///
    /// The file path **SHOULD** contain the extension as it will be used to set the `Content-Type` header.
    case fileContent(pathToFile: String)
  }
}
