import Foundation
import ComposableArchitecture

@Reducer
struct OnboardingCompleteLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        
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
