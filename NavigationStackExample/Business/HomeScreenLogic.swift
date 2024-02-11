import Foundation
import ComposableArchitecture

@Reducer
struct HomeScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var fullName: String?
        var dateOfBirth: Date?
    }
    
    enum Action: Equatable, Sendable {
        case didTapNextButton
    }
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .didTapNextButton:
                return .none
            }
        }
    }
}
