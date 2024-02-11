@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
final class WelcomeScreenLogicTests: XCTestCase {

    func testDidTapNextButton() async {
        
        // TODO: need to figure out a way to override dateOfBirth
//        let store = TestStore(initialState: WelcomeScreenLogic.State()) {
//            WelcomeScreenLogic()
//        } withDependencies: {
//            $0.date.now = Date(timeIntervalSince1970: 1234567890)
//        }
//        
//        await store.send(.didTapNextButton) {
//            $0.path[id: 0] = .yearOfBirthScreen()
//        
//        }
    }
}
