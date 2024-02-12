import Foundation
import ComposableArchitecture

@Reducer
struct FirstNameScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var firstName: String = ""
        var buttonMode: ButtonMode = .disabled
        var focusedField: Field?
        enum Field: String, Hashable {
          case firstName
        }
    }
    enum Action: Equatable, Sendable, BindableAction {
        case binding(BindingAction<State>)
        case didTapNextButton
        case onAppear
        case delegate(Delegate)
        enum Delegate: Equatable, Sendable {
            case navigateToFamilyNameScreen(firstName: String)
        }
    }
    
    @Dependency(\.dataManager) var dataManager
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action>  {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action  {
                
            case .binding(\.firstName):
                state.buttonMode = state.firstName.isWhitespaceOrEmpty ? .disabled : .enabled
                return .none
                
            case .onAppear:
                state.focusedField = .firstName
                return .none
                
            case .didTapNextButton:
                return .run { [firstName = state.firstName] send in
                    await send(.delegate(.navigateToFamilyNameScreen(firstName: firstName)))
                }
                
            case  .delegate(.navigateToFamilyNameScreen):
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
