//
//  Extensions.swift
//
//
//  Created by Vinzenz Weist on 22.10.23.
//

import Foundation
import Network

extension NWParameters {
    /// Default `NWParameters` with options for `WebSocket`
    /// - Parameter url: a `WebSocket` conform url
    /// - Returns: the modified `NWParameters`
    static func options(from url: URL) -> NWParameters {
        var parameters = NWParameters()
        if url.scheme == "ws" { parameters = .tcp } else { parameters = .tls }
        let options = NWProtocolWebSocket.Options(); options.autoReplyPing = true
        parameters.defaultProtocolStack.applicationProtocols.insert(options, at: 0)
        return parameters
    }
}
