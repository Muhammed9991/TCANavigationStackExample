@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
class FirstNameScreenLogicTests: XCTestCase {
    
    func testDidTapNextButton() async {
        let store = TestStore(initialState: FirstNameScreenLogic.State()) {
            FirstNameScreenLogic()
        }
        
        await store.send(.didTapNextButton) 
        await store.receive(.delegate(.navigateToFamilyNameScreen))
    }
    
}
