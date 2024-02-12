import Foundation
import ComposableArchitecture

@Reducer
struct FirstNameScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var path = StackState<Path.State>()
        var firstName: String = ""
        var buttonMode: ButtonMode = .disabled
        var focusedField: Field?
        enum Field: String, Hashable {
          case firstName
        }
    }
    enum Action: Equatable, Sendable, BindableAction {
        case path(StackAction<Path.State, Path.Action>)
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
                
            case let .delegate(.navigateToFamilyNameScreen(firstName: firstName)):
                
                if dataManager.isDataAvailable(from: .namingModel) {
                    state.path.append(.familyNameScreen(FamilyNameScreenLogic.State(firstName: firstName)))
                }
                
                return .none
                
            case .binding:
                return .none
                
            case let .path(action):
                switch action {
                
                case let .element(id: _, action: .familyNameScreen(.delegate(.navigateToNameCompleteScreen(firstName: firstName, familyName: familyName)))):
                    state.path.append(.nameCompleteScreen(NameCompleteLogic.State(firstName: firstName, familyName: familyName)))
                    return .none
                    
                case let .element(id: _, action: .nameCompleteScreen(.delegate(.navigate(firstName: firstName, familyName: familyName)))):
                    
                    return .run { send in
                        let userName = NamingModel(firstName: firstName, familyName: familyName)
                        try await dataManager.save(JSONEncoder().encode(userName), .namingModel)
                        await self.dismiss()
                        
                    }
                default:
                    return .none
                }
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
    
    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable, Sendable {
            case familyNameScreen(FamilyNameScreenLogic.State)
            case nameCompleteScreen(NameCompleteLogic.State)

        }
        enum Action: Equatable, Sendable {
            case familyNameScreen(FamilyNameScreenLogic.Action)
            case nameCompleteScreen(NameCompleteLogic.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: \.familyNameScreen, action: \.familyNameScreen) {
                FamilyNameScreenLogic()
            }
            Scope(state: \.nameCompleteScreen, action: \.nameCompleteScreen) {
                NameCompleteLogic()
            }
        }
    }
}
