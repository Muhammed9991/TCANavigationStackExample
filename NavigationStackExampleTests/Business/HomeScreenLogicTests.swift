@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
final class HomeScreenLogicTests: XCTestCase {
    func testDidTapLogOutButton() async {
        let store = TestStore(initialState: HomeScreenLogic.State()) {
            HomeScreenLogic()
        } withDependencies: {
            $0.dataManager.delete = { _ in }
        }
        
        await store.send(.didTapLogOutButton)
        await store.receive(.delegate(.logOut))
    }
    
    func testDidTapLogOutButtonFaileToDelete() async {
        let store = TestStore(initialState: HomeScreenLogic.State()) {
            HomeScreenLogic()
        } withDependencies: {
            $0.dataManager = .failToDelete
        }
        
        await store.send(.didTapLogOutButton)
        
    }
}
