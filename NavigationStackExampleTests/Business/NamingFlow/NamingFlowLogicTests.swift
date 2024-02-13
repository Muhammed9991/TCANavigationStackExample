@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
class NamingFlowLogicTests: XCTestCase {
    
    func testNavigateFromFirstNameScreenToFamilyNameScreen() async {
        let store = TestStore(initialState: NamingFlowLogic.State(
            namingFlowStack: .firstNameScreen(FirstNameScreenLogic.State())
        )) {
            NamingFlowLogic()
        }
        
        await store.send(.namingFlowStack(.firstNameScreen(.delegate(.navigateToFamilyNameScreen(firstName: "John")))))
        
        await store.receive(.delegate(.navigateToFamilyNameScreen(firstName: "John")))
    }
    
    func testNavigateFromFamilyNameScreenToNameCompleteScreen() async {
        let store = TestStore(initialState: NamingFlowLogic.State(
            namingFlowStack: .familyNameScreen(FamilyNameScreenLogic.State(firstName: "John"))
        )) {
            NamingFlowLogic()
        }
        
        await store.send(.namingFlowStack(.familyNameScreen(.delegate(.navigateToNameCompleteScreen(firstName: "John", familyName: "Doe")))))
        await store.receive(.delegate(.navigateToNameCompleteScreen(firstName: "John", familyName: "Doe")))
    }
    
    func testNavigateFromNameCompleteScreenToFinalNavigation() async {
        let store = TestStore(initialState: NamingFlowLogic.State(
            namingFlowStack: .nameCompleteScreen(NameCompleteLogic.State(firstName: "John", familyName: "Doe"))
        )) {
            NamingFlowLogic()
        }
        
        await store.send(.namingFlowStack(.nameCompleteScreen(.delegate(.navigate(firstName: "John", familyName: "Doe")))))
        
        await store.receive(.delegate(.finalNavigation(firstName: "John", familyName: "Doe")))
    }
}
