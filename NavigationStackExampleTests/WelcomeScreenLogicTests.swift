@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
final class WelcomeScreenLogicTests: XCTestCase {

    func testDidTapNextButton() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State()) {
            WelcomeScreenLogic()
        }
        
        await store.send(.didTapNextButton) {
            $0.path[id: 0] = .yearOfBirthScreen()
        
        }
    }
}
