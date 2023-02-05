import Logging

extension EMLogger {
  public enum Level: String, Decodable {
    /// Appropriate for messages that contain information normally of use only when tracing the execution of a program.
    case trace = "TRACE"
    
    /// Appropriate for messages that contain information normally of use only when debugging a program.
    case debug = "DEBUG"
    
    /// Appropriate for informational messages.
    case info = "INFO"
    
    /// Appropriate for conditions that are not error conditions, but that may require special handling.
    case notice = "NOTICE"
    
    /// Appropriate for messages that are not error conditions, but more severe than `.notice`.
    case warning = "WARNING"
    
    /// Appropriate for error conditions.
    case error = "ERROR"
    
    /// Appropriate for critical error conditions that usually require immediate attention.
    case critical = "CRITICAL"
    
    internal var swiftLogLevel: Logger.Level {
      switch self {
        case .trace:
          return .trace
          
        case .debug:
          return .debug
          
        case .info:
          return .info
          
        case .notice:
          return .notice
          
        case .warning:
          return .warning
          
        case .error:
          return .error
          
        case .critical:
          return .critical
      }
    }
  }
}
