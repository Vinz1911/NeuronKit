import XCTest
@testable import NeuronKit

final class NeuronKitTests: XCTestCase {
    func testExample() {
        let exp = expectation(description: "")
        exp.fulfill()
        wait(for: [exp], timeout: 1)
    }
}
