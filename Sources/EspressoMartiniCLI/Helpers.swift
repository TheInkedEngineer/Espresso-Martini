import ArgumentParser
import EMMockServer
import Foundation

enum Helpers {
  /// Given a root URL, the algorithm will iterate inside of given folder and transforms all valid paths into a `MockServer.NetworkExchange`.
  static func generateEndpoints(from root: URL, networkExchangesFolder: String) throws -> [MockServer.NetworkExchange] {
    guard var baseFolderContents = try? FileManager.default.contentsOfDirectory(at: root, includingPropertiesForKeys: nil) else {
      throw ValidationError("Could not find folder: \(networkExchangesFolder)")
    }
    
    baseFolderContents = baseFolderContents.filter {
      !$0.absoluteString.split(separator: "/", omittingEmptySubsequences: true).last!.starts(with: ".")
    }
    
    return try baseFolderContents.reduce(into: [MockServer.NetworkExchange]()) {
      if $1.hasMethodPath {
        $0.append(try networkExchange(at: $1, relativeTo: networkExchangesFolder))
      } else {
        guard $1.hasDirectoryPath else {
          return
        }
        
        $0.append(contentsOf: try! generateEndpoints(from: $1, networkExchangesFolder: networkExchangesFolder))
      }
    }
  }
  
  /// Generates a `MockServer.NetworkExchange` from a `URL`.
  private static func networkExchange(at url: URL, relativeTo baseFolderName: String) throws -> MockServer.NetworkExchange {
    let configurationURL = url.appendingPathComponent("configuration.json")
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    guard let configurationData = FileManager.default.contents(atPath: configurationURL.relativePath) else {
      // If no custom configuration is present, just return the default values of `MockServer.Response`.
      return MockServer.NetworkExchange(request: generateRequest(at: url, relativeTo: baseFolderName), response: MockServer.Response())
    }
    
    let configuration: [NetworkExchangeConfiguration]
    
    if let decodedObject = try? decoder.decode(NetworkExchangeConfiguration.self, from: configurationData) {
      configuration = [decodedObject]
    } else if let decodedArray = try? decoder.decode([NetworkExchangeConfiguration].self, from: configurationData) {
      configuration = decodedArray
    } else {
      throw ValidationError("Configuration file at: \(configurationURL.relativePath) is invalid.")
    }
    
    return MockServer.NetworkExchange(
      request: generateRequest(at: url, relativeTo: baseFolderName),
      response: try generateResponse(at: url, from: configuration)
    )
  }
  
  /// Generates the `MockServer.Request` from the passed `URL`
  private static func generateRequest(at url: URL, relativeTo baseFolderName: String) -> MockServer.Request {
    MockServer.Request(
      method: url.httpMethod,
      path: Helpers.path(from: url, relativeTo: baseFolderName)
    )
  }
  
  /// Generates the `MockServer.Response` from the configuration.
  private static func generateResponse(at url: URL, from configuration: [NetworkExchangeConfiguration]) throws -> [MockServer.Response] {
    try configuration.reduce(into: [MockServer.Response]()) { responses, configuration in
      if let responseFile = configuration.responseFile {
        let responseFilePath = url.appendingPathComponent("\(responseFile)")
        
        guard FileManager.default.fileExists(atPath: responseFilePath.relativePath) else {
          throw ValidationError("Missing file at: \(responseFilePath.relativePath).")
        }
        
        responses.append(
          MockServer.Response(
            status: HTTPResponseStatus(statusCode: configuration.statusCode),
            headers: HTTPHeaders(configuration.unwrappedHeaders.map {($0.key, $0.value)}),
            kind: .fileContent(pathToFile: url.appending(responseFile).relativePath),
            delay: configuration.delay
          )
        )
      } else {
        responses.append(
          MockServer.Response(
            status: HTTPResponseStatus(statusCode: configuration.statusCode),
            headers: HTTPHeaders(configuration.unwrappedHeaders.map {($0.key, $0.value)}),
            kind: .empty,
            delay: configuration.delay
          )
        )
      }
    }
  }
  
  /// Generates the `Path` for the request from the URL following the conventions:
  /// - all requests start from `baseFolder`
  /// - all requests ends at an `HTTP` method
  /// - The request path is formed from the name of each folder leading to the method.
  private static func path(from url: URL, relativeTo baseFolderName: String) -> Path {
    url.absoluteString
      .split(separator: "/")
      .drop { $0 != baseFolderName }
      .dropFirst() // drop the base folder
      .dropLast() // drop the http method
      .map { String($0) }
  }
}

extension Helpers {
  private struct NetworkExchangeConfiguration: Decodable {
    let statusCode: Int
    let headers: [String: String]?
    let responseFile: String?
    let delay: TimeInterval?
    
    var unwrappedHeaders: [String: String] {
      headers ?? [:]
    }
  }
}
