//
//  NKConnectionProtocol.swift
//  
//
//  Created by Vinzenz Weist on 22.10.23.
//

import Foundation

public protocol NKConnectionProtocol {
    var stateUpdateHandler: (NKConnectionState) -> Void { get set }
    /// Start the connection to a
    /// compatible `WebSocket` server
    func start() -> Void
    /// Cancel all active `WebSocket` connections
    /// from the server
    func cancel() -> Void
    /// Send a `WebSocket` compliant message
    /// - Parameter message: the message to be send
    func send<T: NKConnectionMessage>(message: T) -> Void
    /// Receive `WebSocket` compliant messages
    /// - Parameter completion: completion block contains `NKConnectionMessage` and `NKConnectionBytes`
    func receive(_ completion: @escaping (NKConnectionMessage?, NKConnectionBytes?) -> Void) -> Void
}
