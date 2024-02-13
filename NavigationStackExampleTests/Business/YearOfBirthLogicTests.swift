@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
final class YearOfBirthLogicTests: XCTestCase {
    
    func testDidTapNextButton_where_userIsUnder18() async {
        let store = TestStore(initialState: YearOfBirthLogic.State()) {
            YearOfBirthLogic()
        } withDependencies: {
            $0.ageHelper.isUser18orAbove = { _ in false }
            $0.date.now = DateFormatter.date(fromString: "2010-01-01 00:00:00 +0000")!
        }
        
        await store.send(.didTapNextButton(dateOfBirth: Date(timeIntervalSince1970: 123456789)))
        await store.receive(.navigateToOnBoardingCompleteScreen(dateOfBirth: Date(timeIntervalSince1970: 123456789)))
    }
    
    func testDidTapNextButton_where_userIsOver18() async {
        let store = TestStore(initialState: YearOfBirthLogic.State()) {
            YearOfBirthLogic()
        } withDependencies: {
            $0.ageHelper.isUser18orAbove = { _ in true }
            $0.date.now = DateFormatter.date(fromString: "1990-01-01 00:00:00 +0000")!
        }
        
        await store.send(.didTapNextButton(dateOfBirth: Date(timeIntervalSince1970: 123456789)))
        await store.receive(.navigateToNamingFlow)
    }
}


private extension DateFormatter {
    static func date(fromString dateString: String, format: String = "yyyy-MM-dd HH:mm:ss Z") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
}
