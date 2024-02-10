@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
class FirstNameScreenLogicTests: XCTestCase {
    
    func testDidTapNextButton() async {
        let store = TestStore(initialState: FirstNameScreenLogic.State()) {
            FirstNameScreenLogic()
        }
        
        await store.send(.didTapNextButton) {
            $0.path[id: 0] = .familyNameScreen()
        }
            
        
    }
    
}
