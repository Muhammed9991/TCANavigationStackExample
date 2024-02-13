@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
class FamilyNameScreenLogicTests: XCTestCase {
    func testFamilyNameBindingEmpty() async {
        let store = TestStore(initialState: FamilyNameScreenLogic.State(firstName: "John", familyName: "Doe", buttonMode: .enabled)) {
            FamilyNameScreenLogic()
        }
        
        await store.send(.binding(.set(\.familyName, ""))) {
            $0.familyName = ""
            $0.buttonMode = .disabled
        }
    }
    
    func testFamilyNameBindingHasWhiteSpace() async {
        let store = TestStore(initialState: FamilyNameScreenLogic.State(firstName: "John", familyName: "Doe", buttonMode: .enabled)) {
            FamilyNameScreenLogic()
        }
        
        await store.send(.binding(.set(\.familyName, "  "))) {
            $0.familyName = "  "
            $0.buttonMode = .disabled
        }
    }
    
    func testFamilyNameBindingWithText() async {
        let store = TestStore(initialState: FamilyNameScreenLogic.State(firstName: "John", familyName: "Doe", buttonMode: .disabled)) {
            FamilyNameScreenLogic()
        }
        
        await store.send(.binding(.set(\.familyName, "Doe"))) {
            $0.familyName = "Doe"
            $0.buttonMode = .enabled
        }
    }
    
    func testOnAppear() async {
        let store = TestStore(initialState: FamilyNameScreenLogic.State(firstName: "John")) {
            FamilyNameScreenLogic()
        }
        
        await store.send(.onAppear) {
            $0.focusedField = .familyName
        }
    }
    
    func testDidTapNextButton() async {
        let store = TestStore(initialState: FamilyNameScreenLogic.State(firstName: "John", familyName: "Doe")) {
            FamilyNameScreenLogic()
        }
        
        await store.send(.didTapNextButton)
        await store.receive(.delegate(.navigateToNameCompleteScreen(firstName: "John", familyName: "Doe")))
        
    }
}
