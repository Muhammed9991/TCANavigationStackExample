@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
class FirstNameScreenLogicTests: XCTestCase {
    
    func testFirstNameBindingEmpty() async {
        let store = TestStore(initialState: FirstNameScreenLogic.State(firstName: "John", buttonMode: .enabled)) {
            FirstNameScreenLogic()
        }
        
        await store.send(.binding(.set(\.firstName, ""))) {
            $0.firstName = ""
            $0.buttonMode = .disabled
        }
    }
    
    func testFirstNameBindingHasWhiteSpace() async {
        let store = TestStore(initialState: FirstNameScreenLogic.State(firstName: "John", buttonMode: .enabled)) {
            FirstNameScreenLogic()
        }
        
        await store.send(.binding(.set(\.firstName, "  "))) {
            $0.firstName = "  "
            $0.buttonMode = .disabled
        }
    }
    
    func testFirstNameBindingWithText() async {
        let store = TestStore(initialState: FirstNameScreenLogic.State(buttonMode: .disabled)) {
            FirstNameScreenLogic()
        }
        
        await store.send(.binding(.set(\.firstName, "John"))) {
            $0.firstName = "John"
            $0.buttonMode = .enabled
        }
    }
    
    func testOnappear() async {
        let store = TestStore(initialState: FirstNameScreenLogic.State()) {
            FirstNameScreenLogic()
        }
        
        await store.send(.onAppear) {
            $0.focusedField = .firstName
        }
    }
    
    func testDidTapNextButton() async {
        let store = TestStore(initialState: FirstNameScreenLogic.State(firstName: "John")) {
            FirstNameScreenLogic()
        }
        
        await store.send(.didTapNextButton) 
        await store.receive(.delegate(.navigateToFamilyNameScreen(firstName: "John")))
    }
    
}
