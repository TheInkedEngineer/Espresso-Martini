import Vapor

public struct EMLogger: LogHandler {
  /// The `logLevel` is set to `.trace` to track all events.
  public var logLevel: Logger.Level

  /// The dictionary of metadata that are relevant to all logs.
  /// - Note: These metadata should be merged to the ones related to the single log.
  public var metadata: Logger.Metadata = [:]
  
  private var prettyDate: String {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .medium
    dateFormatter.dateStyle = .short
    return dateFormatter.string(from: .now)
  }
  
  public init(logLevel: EMLogger.Level) {
    self.logLevel = logLevel.swiftLogLevel
  }
  
  /// This method is called when a `LogHandler` must emit a log message. There is no need for the `LogHandler` to
  /// check if the `level` is above or below the configured `logLevel` as `Logger` already performed this check and
  /// determined that a message should be logged.
  ///
  /// - parameters:
  ///     - level: The log level the message was logged at.
  ///     - message: The message to log. To obtain a `String` representation call `message.description`.
  ///     - metadata: The metadata associated to this log message.
  ///     - source: The source where the log message originated, for example the logging module.
  ///     - file: The file the log message was emitted from.
  ///     - function: The function the log line was emitted from.
  ///     - line: The line the log message was emitted from.
  public func log(
    level: Logger.Level,
    message: Logger.Message,
    metadata: Logger.Metadata?,
    source: String = "EMMockServer",
    file: String = #fileID,
    function: String = #function,
    line: UInt = #line
  ) {
    print("\(prettyDate) \(level): [\(source)] \(message)")
  }
}

extension EMLogger {
  /// Accesses the `metadata` dictionary using a key.
  /// This subscript is required to conform to `LogHandler` protocol.
  public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
    get {
      metadata[key]
    }

    set {
      metadata[key] = newValue
    }
  }
}
