import SwiftUI
import ComposableArchitecture

@Reducer
struct NamingFlowLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var namingFlowStack: NamingFlowStack.State? = .firstNameScreen(FirstNameScreenLogic.State())
    }
    enum Action: Equatable, Sendable {
        case namingFlowStack(NamingFlowStack.Action)
        case onAppear
        case delegate(Delegate)
        enum Delegate: Equatable, Sendable {
            case navigateToFamilyNameScreen(firstName: String)
            case navigateToNameCompleteScreen(fullName: String)
            case finalNavigation
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case let .namingFlowStack(.firstNameScreen(.delegate(.navigateToFamilyNameScreen(firstName: firstName)))):
                return .send(.delegate(.navigateToFamilyNameScreen(firstName: firstName)))
                
            case let .namingFlowStack(.familyNameScreen(.delegate(.navigateToNameCompleteScreen(fullName: fullName)))):
                return .send(.delegate(.navigateToNameCompleteScreen(fullName: fullName)))
                
            case .namingFlowStack(.nameCompleteScreen(.delegate(.navigate))):
                return .send(.delegate(.finalNavigation))
            
            case .namingFlowStack, .delegate:
                return .none
            }
        }
        .ifLet(\.namingFlowStack, action: \.namingFlowStack) {
            NamingFlowStack()
        }
    }
}
