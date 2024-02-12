import Foundation
import ComposableArchitecture

@Reducer
struct NameCompleteLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var firstName: String
        var familyName: String
        var fullName: String {
            return "\(firstName) \(familyName)"
        }
    }
    enum Action: Equatable, Sendable {
        case didTapNextButton
        case delegate(Delegate)
        enum Delegate: Equatable, Sendable {
            case navigate(firstName: String, familyName: String)
        }
    }
    
    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action  {
            case .didTapNextButton:
                return .send(.delegate(.navigate(firstName: state.firstName, familyName: state.familyName)))
                
            case .delegate(.navigate):
                return .none
            }
        }
    }
}
