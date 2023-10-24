//
//  NKConnection.swift
//
//
//  Created by Vinzenz Weist on 22.10.23.
//

import Foundation
import Network


public final class NKConnection: NKConnectionProtocol {
    public var stateUpdateHandler: (NKConnectionState) -> Void = { _ in }
    private var transmitter: (NKTransmitter) -> Void = { _ in }
    
    private var connection: NWConnection
    private var queue = DispatchQueue(label: UUID().uuidString)
    
    public required init(url: URL) {
        self.connection = NWConnection(to: .url(url), using: .options(from: url))
    }
    
    /// Start the connection to a
    /// compatible `WebSocket` server
    public func start() -> Void {
        handler(); receive()
        connection.start(queue: queue)
    }
    
    /// Cancel all active `WebSocket` connections
    /// from the server
    public func cancel() -> Void {
        connection.cancel()
    }
    
    /// Send a `WebSocket` compliant message
    /// - Parameter message: the message to be send
    public func send<T: NKConnectionMessage>(message: T) -> Void {
        let context = message.context
        let data = message.content
        process(from: data, with: context)
    }
    
    /// Receive `WebSocket` compliant messages
    /// - Parameter completion: completion block contains `NKConnectionMessage` and `NKConnectionBytes`
    public func receive(_ completion: @escaping (NKConnectionMessage?, NKConnectionBytes?) -> Void) -> Void {
        transmitter = { result in
            switch result {
            case .message(let message): completion(message, nil)
            case .bytes(let bytes): completion(nil, bytes) }
        }
    }
}

// MARK: - Private API -

private extension NKConnection {
    /// The state update handler
    private func handler() -> Void {
        connection.stateUpdateHandler = { [weak self] state in
            guard let self else { return }
            switch state {
            case .ready: stateUpdateHandler(.ready)
            case .failed(let error): stateUpdateHandler(.failed(error))
            case .cancelled: stateUpdateHandler(.cancelled)
            default: break }
        }
    }
    
    /// Process the data that should be send to the server
    /// - Parameters:
    ///   - data: the transmit data
    ///   - context: data context (.text or .binary)
    private func process(from data: Data, with context: NWConnection.ContentContext) -> Void {
        connection.batch {
            connection.send(content: data, contentContext: context, isComplete: true, completion: .contentProcessed({ [weak self] error in
                guard let self else { return }
                transmitter(.bytes(.init(output: data.count)))
                guard let error else { return }
                stateUpdateHandler(.failed(error))
            }))
        }
    }
    
    /// Parse the received data from the server
    /// - Parameters:
    ///   - data: the received data
    ///   - context: data context (.text or .binary)
    private func parse(from data: Data, with context: NWConnection.ContentContext) -> Void {
        guard let metadata = context.protocolMetadata.first as? NWProtocolWebSocket.Metadata else { return }
        transmitter(.bytes(.init(input: data.count)))
        switch metadata.opcode {
        case .text: guard let message = String(data: data, encoding: .utf8) else { return }; transmitter(.message(message))
        case .binary: let message = data; transmitter(.message(message))
        default: break }
    }
    
    /// Receive and parse the incoming data
    private func receive() -> Void {
        connection.batch {
            connection.receiveMessage { [weak self] data, context, _, error in
                guard let self else { return }
                if let data = data, !data.isEmpty, let context = context { parse(from: data, with: context) }
                guard let error else { receive(); return }
                stateUpdateHandler(.failed(error))
            }
        }
    }
}
