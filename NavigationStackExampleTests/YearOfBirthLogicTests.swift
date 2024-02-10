@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
final class YearOfBirthLogicTests: XCTestCase {
    
    func testDidTapNextButton_where_userIsUnder18() async {
        let store = TestStore(initialState: YearOfBirthLogic.State(dateOfBirth: "2010-01-01 00:00:00 +0000")) {
            YearOfBirthLogic()
        } withDependencies: {
            $0.ageHelper.isUser18orAbove = { _ in false }
            $0.date.now = Date(timeIntervalSince1970: 1234567890)
        }
        
        await store.send(.didTapNextButton) {
            $0.path[id: 0] = .onboardingCompleteScreen()
        }
    }
}


