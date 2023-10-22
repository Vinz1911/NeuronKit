//
//  File.swift
//  
//
//  Created by Vinzenz Weist on 22.10.23.
//

import Foundation

import Foundation

/// The `NKConnectionBytes` for input and output bytes
public struct NKConnectionBytes /*: FKConnectionBytesProtocol */ {
    public var input: Int?
    public var output: Int?
}

// MARK: - State Types -

/// The `NKTransmitter` internal message transmitter
@frozen
internal enum NKTransmitter {
    case message(NKConnectionMessage)
    case bytes(NKConnectionBytes)
}

/// The `FKConnectionState` state handler
@frozen
public enum NKConnectionState {
    case ready
    case cancelled
    case failed(Error?)
}
