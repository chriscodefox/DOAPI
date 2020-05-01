import XCTest
@testable import DOAPI

final class DOAPITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let digitalOcean = DigitalOcean(apiToken: "fakeapi")
        XCTAssertNotNil(digitalOcean)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
