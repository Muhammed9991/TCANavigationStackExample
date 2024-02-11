@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
class NamingFlowLogicTests: XCTestCase {
    
    func testOnAppear() async {
        let store = TestStore(initialState: NamingFlowLogic.State()) {
            NamingFlowLogic()
        }
        
        await store.send(.onAppear) {
            $0.namingFlowStack = .firstNameScreen(FirstNameScreenLogic.State())
        }
    }
    
}
