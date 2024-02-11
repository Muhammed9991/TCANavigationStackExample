@testable import NavigationStackExample
import XCTest
import Dependencies

class AgeHelperTests: XCTestCase {

    func testUserIs18orAbove() {
        let sut = withDependencies {
            $0.date.now = Date(timeIntervalSince1970: 1234567890)
        } operation: {
            AgeHelper.liveValue
        }

        XCTAssertTrue(sut.isUser18orAbove(dateOfBirth: "1990-01-01 00:00:00 +0000"))
    }

    func testUserIsUnder18() {
        let sut = withDependencies {
            $0.date.now = Date(timeIntervalSince1970: 1234567890)
        } operation: {
            AgeHelper.liveValue
        }
        
        XCTAssertFalse(sut.isUser18orAbove(dateOfBirth: "2010-01-01 00:00:00 +0000"))
    }

    func testInvalidDateFormat() {
        let sut = withDependencies {
            $0.date.now = Date(timeIntervalSince1970: 1234567890)
        } operation: {
            AgeHelper.liveValue
        }
        
        XCTAssertFalse(sut.isUser18orAbove(dateOfBirth: "InvalidDate"))
    }

}
