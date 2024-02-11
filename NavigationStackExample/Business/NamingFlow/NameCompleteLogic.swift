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
            case navigate
        }
    }
    
    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action  {
            case .didTapNextButton:
                return .send(.delegate(.navigate))
                
            case .delegate(.navigate):
                return .none
            }
        }
    }
}
