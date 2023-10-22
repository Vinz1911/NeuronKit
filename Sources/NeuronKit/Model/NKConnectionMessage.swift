//
//  NKConnectionMessage.swift
//  
//
//  Created by Vinzenz Weist on 22.10.23.
//

import Foundation
import Network

public protocol NKConnectionMessage {
    var context: NWConnection.ContentContext { get }
    var content: Data { get }
    
}

extension String: NKConnectionMessage {
    public var content: Data { self.data(using: .utf8) ?? .init() }
    public var context: NWConnection.ContentContext {
        let metadata = NWProtocolWebSocket.Metadata(opcode: .text)
        let context = NWConnection.ContentContext(identifier: "textContext", metadata: [metadata])
        return context
    }
}

extension Data: NKConnectionMessage {
    public var content: Data { self }
    public var context: NWConnection.ContentContext {
        let metadata = NWProtocolWebSocket.Metadata(opcode: .binary)
        let context = NWConnection.ContentContext(identifier: "binaryContext", metadata: [metadata])
        return context
    }
}
