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
    
    func run() throws {
      let baseFolderURL = URL(string: FileManager.default.currentDirectoryPath)!.appending(baseFolder)
      // Cleanup dir name. Example: somefolder/example-network-exchanges/ -> example-network-exchanges
      let cleanedBaseFolderName = String(baseFolder.split(separator: "/").last!)
        
      let networkExchanges = try Helpers.generateEndpoints(from: baseFolderURL, networkExchangesFolder: cleanedBaseFolderName)
      let groupedNetworkExchanges = Dictionary(grouping: networkExchanges, by: {$0.request.pathAsString})
      groupedNetworkExchanges.forEach {
        print("Endpoint: \($0.key)")
        $0.value.forEach {
          print("|-- Method: \($0.request.method)")
          $0.response
            .enumerated()
            .forEach {
              print("    |-- Response number \($0.offset + 1):")
              print("        |-- Expected Status Code: \($0.element.status.code)")
              print("        |-- Expected Headers: \($0.element.headers)")
              print("        |-- Expected Response kind: \($0.element.kind)")
              print("        |-- Expected Response Delay: \(($0.element.delay != nil) ? String($0.element.delay!) : "N/A")")
              print("")
          }
        }
      }
    }
  }
}
