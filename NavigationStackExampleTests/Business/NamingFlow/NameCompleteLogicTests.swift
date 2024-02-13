@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
class NameCompleteLogicTests: XCTestCase {
    func testDidTapNextButton() async {
        let store = TestStore(initialState: NameCompleteLogic.State(firstName: "John", familyName: "Doe")) {
            NameCompleteLogic()
        }
        
        await store.send(.didTapNextButton)
        await store.receive(.delegate(.navigate(firstName: "John", familyName: "Doe")))
    }
}
