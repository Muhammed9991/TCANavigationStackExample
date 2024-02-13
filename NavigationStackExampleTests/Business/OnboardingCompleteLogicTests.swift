@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
final class OnboardingCompleteLogicTests: XCTestCase {
    func testOnAppear() async {
        let store = TestStore(initialState: OnboardingCompleteLogic.State(dateOfBirth: Date(timeIntervalSince1970: 12345678))) {
            OnboardingCompleteLogic()
        } withDependencies: {
            $0.dataManager = .mock()
        }
        
        await store.send(.onAppear)
    }
}
