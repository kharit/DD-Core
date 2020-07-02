import XCTest
@testable import DDCore

final class DDCoreTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(DDCore().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
