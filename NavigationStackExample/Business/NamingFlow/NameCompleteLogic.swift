import Foundation
import ComposableArchitecture

@Reducer
struct NameCompleteLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var fullName: String
    }
    enum Action: Equatable, Sendable {
        case didTapNextButton
        case delegate(Delegate)
        enum Delegate: Equatable, Sendable {
            case navigate(fullName: String)
        }
    }
    
    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action  {
            case .didTapNextButton:
                return .send(.delegate(.navigate(fullName: state.fullName)))
                
            case .delegate(.navigate):
                return .none
            }
        }
    }
}
