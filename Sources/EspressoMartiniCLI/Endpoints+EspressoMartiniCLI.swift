import ArgumentParser
import EMMockServer
import Foundation

extension EspressoMartiniCLI {
  struct Endpoints: ParsableCommand {
    static let configuration = CommandConfiguration(
      commandName: "endpoints",
      abstract: "Returns a list of all the properly configured endpoints on the local server."
    )
    
    @Option(
      wrappedValue: "network-exchanges",
      name: [.customLong("requests-folder")],
      help: "The name of the base folder where the requests resides."
    )
    var baseFolder: String
    
    @Flag
    var verbose = false
    
    func run() throws {
      let baseFolderURL = URL(string: FileManager.default.currentDirectoryPath)!.appending(baseFolder)
      
      try Helpers.generateEndpoints(from: baseFolderURL, networkExchangesFolder: baseFolder).forEach {
        $0.prettyPrint(verbose: verbose)
      }
    }
  }
}
