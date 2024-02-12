import Foundation
import ComposableArchitecture

@Reducer
struct FamilyNameScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var firstName: String
        var familyName: String = ""
        var buttonMode: ButtonMode = .disabled
        
        var focusedField: Field?
        enum Field: String, Hashable {
          case familyName
        }
    }
    enum Action: Equatable, Sendable, BindableAction {
        case binding(BindingAction<State>)
        case didTapNextButton
        case onAppear
        case delegate(Delegate)
        enum Delegate: Equatable, Sendable {
            case navigateToNameCompleteScreen(firstName: String, familyName: String)
        }
    }
    
    var body: some Reducer<State, Action>  {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action  {
                
            case .binding(\.familyName):
                state.buttonMode = state.familyName.isWhitespaceOrEmpty ? .disabled : .enabled
                return .none
                
            case .onAppear:
                state.focusedField = .familyName
                return .none
                
            case .didTapNextButton:
                return .run { [firstName = state.firstName, familyName = state.familyName] send in
                    await send(.delegate(.navigateToNameCompleteScreen(firstName: firstName, familyName: familyName)))
                }
                
            case .delegate(.navigateToNameCompleteScreen):
                return .none
            
            case .binding:
                return .none
            }
        }
    }
}
