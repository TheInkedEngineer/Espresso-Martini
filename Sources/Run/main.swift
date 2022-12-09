import EMMockServer
import Vapor

let server = MockServer()
try? server.configure(using: ServerConfiguration(networkExchanges: Demo.networkExchanges))
try? server.run()

defer {
  Task {
    try? await server.stop()
  }
}

struct ServerConfiguration: ServerConfigurationProvider {
  let environment: MockServer.Environment = .development
  let hostname: String = "127.0.0.1"
  let port: Int = 8080
  let networkExchanges: [MockServer.NetworkExchange]
}
