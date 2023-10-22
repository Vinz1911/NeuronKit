import XCTest
@testable import NeuronKit

final class NeuronKitTests: XCTestCase {
    func testExample() {
        let exp = expectation(description: "")
        let neuron = NKConnection(url: URL(string: "ws://localhost:8080/echo")!)
        let bigData = Data(count: 1024 * 102)
        neuron.stateUpdateHandler = { state in
            switch state {
            case .ready: print("ready")
                for i in 0...100000 {
                    neuron.send(message: bigData)
                }
            case .cancelled: print("cancelled")
            case .failed(let error): if let error { print(error) } }
        }
        neuron.receive { message, bytes in
            if case let message as String = message {
                //print(message)
                //neuron.send(message: bigData)
            }
        }
        neuron.start()
        wait(for: [exp], timeout: 100)
    }
}
