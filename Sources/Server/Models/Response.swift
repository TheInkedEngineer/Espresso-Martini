import Foundation
import Vapor

/// An object associated with the `Request` reflecting the desired `Response` by the user.
public struct Response {
  /// The HTTP response status.
  public let status: HTTPResponseStatus

  /// The header fields for this HTTP response.
  ///
  /// The `"Content-Length"` and `"Transfer-Encoding"` headers will be set automatically when the `body` property is mutated.
  public let headers: HTTPHeaders

  /// The path to the file associated with the response. **SHOULD** contain file extension.
  ///
  /// The file extension will automatically set the value for `Content-Type` in the headers, and will override any passed value in the headers section.
  /// Whenever the status code does not support a body, like `HTTPResponseStatus.noContent`, This file will be discarded.
  public let pathToFile: String?
  
  /// The data extracted from the file.
  public var data: Data? {
    #warning("Needs to implement logic.")
    return nil
  }

  /// Returns an instance of `RequestedResponse`
  /// - Parameters:
  ///   - status: The HTTP response status. Defaults to `.ok`.
  ///   - headers: The header fields for this HTTP response.
  ///   - pathToFile: A string pointing to the path containing the data associated with the response.
  public init(
    status: HTTPResponseStatus = .ok,
    headers: HTTPHeaders = [:],
    pathToFile: String? = nil
  ) {
    self.status = status
    self.pathToFile = status.mayHaveResponseBody ? pathToFile : nil
    
    if
      let fileExtension = pathToFile?.split(separator: ".").last,
      let contentType = HTTPMediaType.fileExtension(String(fileExtension))?.serialize()
    {
      // We override the `Content-Type` to align it with the data being sent.
      self.headers = headers.replacingOrAdding(name: "Content-Type", value: contentType)
    } else {
      // If there is not content to send, then `Content-Type` should not exist.
      self.headers = headers.removing(name: "Content-Type")
    }
  }
}
