import ArgumentParser
import Foundation
import EMMockServer

struct EspressoMartiniCLI: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "espressomartini",
    abstract: "Manage your Espresso Martini server from the command line.",
    discussion: "Interact with your Espresso Martini local server straight from the command line.",
    subcommands: [Run.self]
  )
}

extension EspressoMartiniCLI {
  struct Run: ParsableCommand {
    static let configuration = CommandConfiguration(
      commandName: "run",
      abstract: "Runs the Espresso Martini server.",
      discussion: "To configure the server add a configuration file through the `configuration` option."
    )
    
    @Option(wrappedValue: "", name: [.customLong("configuration")], help: "The path to the configuration file.")
    var configurationFile: String
    
    func run() throws {
      let mockServerConfiguration: ServerConfigurationProvider
      
      if !configurationFile.isEmpty {
        let configurationURL: URL = {
          if #available(macOS 13.0, *), #available(iOS 16.0, *) {
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
        
        mockServerConfiguration = MockServer.Configuration(
          networkExchanges: [],
          environment: configuration.environment,
          hostname: configuration.hostname,
          port: configuration.port,
          delay: configuration.delay
        )
      } else {
        mockServerConfiguration = MockServer.SimpleConfiguration(networkExchanges: [])
      }
      
      let mockServer = MockServer()
      try mockServer.configure(using: mockServerConfiguration)
      try mockServer.run()
      
      let promise = mockServer.vaporApplication!.eventLoopGroup.next().makePromise(of: Void.self)
      mockServer.vaporApplication!.running = .start(using: promise)
      try mockServer.vaporApplication?.running?.onStop.wait()
      
      // setup signal sources for shutdown
      let signalQueue = DispatchQueue(label: "com.theinkedengineer.espressoMartini.shutdown")
      func makeSignalSource(_ code: Int32) {
          let source = DispatchSource.makeSignalSource(signal: code, queue: signalQueue)
          source.setEventHandler {
              print() // clear ^C
              promise.succeed(())
          }
          source.resume()
          signal(code, SIG_IGN)
      }
      makeSignalSource(SIGTERM)
      makeSignalSource(SIGINT)
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
