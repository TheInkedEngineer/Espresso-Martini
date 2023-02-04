import ArgumentParser
import Foundation
import EMMockServer

struct EspressoMartiniCLI: ParsableCommand {
  static let configuration = CommandConfiguration(
    commandName: "espressomartini",
    abstract: "Manage your Espresso Martini server from the command line.",
    discussion: "Interact with your Espresso Martini local server straight from the command line.",
    subcommands: [Run.self, Endpoints.self]
  )
}
