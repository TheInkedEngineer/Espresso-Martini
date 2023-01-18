import ArgumentParser
import Foundation
import EMMockServer

struct EMLocalServer: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "espressomartini",
    abstract: "Manage your Espresso Martini server from the command line.",
    discussion: "Interact with your Espresso Martini local server straight from the command line.",
    subcommands: [Run.self]
  )
}

extension EMLocalServer {
  struct Run: ParsableCommand {
    static let configuration = CommandConfiguration(
      commandName: "run",
      abstract: "Runs the Espresso Martini server.",
      discussion: "To configure the server add a configuration file through the `configuration` option."
    )
    
    @Option(wrappedValue: "", name: [.customLong("configuration")], help: "The path to the configuration file.")
    var configurationFile: String
    
    func run() throws {
      let mockServerConfiguration: MockServerConfiguration
      
      if !configurationFile.isEmpty {
        let configurationURL: URL = {
          if #available(macOS 13.0, *) {
            return URL(string: FileManager.default.currentDirectoryPath)!
              .appending(path: configurationFile)
          } else {
            return URL(string: FileManager.default.currentDirectoryPath)!
              .appendingPathComponent(configurationFile)
          }
        }()
        
        guard let configurationData = FileManager.default.contents(atPath: configurationURL.absoluteString) else {
          throw ValidationError("Could not find \(configurationURL.absoluteString)")
        }
        
        guard let configuration = try? JSONDecoder().decode(ServerConfiguration.self, from: configurationData) else {
          throw ValidationError("Configuration file at: \(configurationURL.absoluteString) is invalid.")
        }
        
        mockServerConfiguration = MockServerConfiguration(
          networkExchanges: [],
          environment: configuration.environment,
          hostname: configuration.hostname,
          port: configuration.port,
          delay: configuration.delay
        )
      } else {
        mockServerConfiguration = MockServerConfiguration(
          networkExchanges: [],
          environment: .development,
          hostname: "127.0.0.1",
          port: 8080,
          delay: 0
        )
      }
      
      let mockServer = MockServer()
      try mockServer.configure(using: mockServerConfiguration)
      try mockServer.run()
    }
  }
}

private struct ServerConfiguration: Decodable {
  let environment: MockServer.Environment
  let hostname: String
  let port: Int
  let delay: TimeInterval
  
  enum CodingKeys: CodingKey {
    case environment
    case hostname
    case port
    case delay
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.environment = try container.decodeIfPresent(MockServer.Environment.self, forKey: .environment) ?? .development
    self.hostname = try container.decode(String.self, forKey: .hostname)
    self.port = try container.decode(Int.self, forKey: .port)
    self.delay = try container.decodeIfPresent(TimeInterval.self, forKey: .delay) ?? 0
  }
}
