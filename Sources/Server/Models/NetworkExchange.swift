import Foundation

/// An object representing a network exchange made of a ``Request`` and ``Response``.
public struct NetworkExchange {
  /// A ``Request`` object.
  let request: Request
  
  /// A ``Response`` object.
  let response: Response
}
