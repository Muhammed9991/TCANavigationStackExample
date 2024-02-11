import Foundation
import ComposableArchitecture

@Reducer
struct FamilyNameScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable { }
    enum Action: Equatable, Sendable {
        case didTapNextButton
        case delegate(Delegate)
        enum Delegate: Equatable, Sendable {
            case navigateToNameCompleteScreen
        }
    }
    
    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action  {
            case .didTapNextButton:
                return .send(.delegate(.navigateToNameCompleteScreen))
                
            case .delegate(.navigateToNameCompleteScreen):
                return .none
            }
        }
    }
}
