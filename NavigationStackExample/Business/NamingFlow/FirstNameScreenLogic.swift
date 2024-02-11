import Foundation
import ComposableArchitecture

@Reducer
struct FirstNameScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable { }
    enum Action: Equatable, Sendable {
        case didTapNextButton
        case delegate(Delegate)
        enum Delegate: Equatable, Sendable {
            case navigateToFamilyNameScreen
        }
    }
    
    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action  {
            case .didTapNextButton:
                return .send(.delegate(.navigateToFamilyNameScreen))
                
            case .delegate(.navigateToFamilyNameScreen):
                return .none
            }
        }
    }
}
