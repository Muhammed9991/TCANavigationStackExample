import Foundation
import ComposableArchitecture

@Reducer
struct FamilyNameScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var firstName: String
        var lastName: String = ""
        var buttonMode: ButtonMode = .disabled
        var fullName: String {
            return "\(firstName) \(lastName)"
        }
        
        var focusedField: Field?
        enum Field: String, Hashable {
          case lastName
        }
    }
    enum Action: Equatable, Sendable, BindableAction {
        case binding(BindingAction<State>)
        case didTapNextButton
        case onAppear
        case delegate(Delegate)
        enum Delegate: Equatable, Sendable {
            case navigateToNameCompleteScreen(fullName: String)
        }
    }
    
    var body: some Reducer<State, Action>  {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action  {
                
            case .binding(\.lastName):
                state.buttonMode = state.lastName.isWhitespaceOrEmpty ? .disabled : .enabled
                return .none
                
            case .onAppear:
                state.focusedField = .lastName
                return .none
                
            case .didTapNextButton:
                return .run { [fullName = state.fullName] send in
                    await send(.delegate(.navigateToNameCompleteScreen(fullName: fullName)))
                }
                
            case .delegate(.navigateToNameCompleteScreen):
                return .none
            
            case .binding:
                return .none
            }
        }
    }
}
