import Foundation
import ComposableArchitecture

@Reducer
struct FamilyNameScreenLogic {
    struct State: Equatable, Sendable {
        var path = StackState<Path.State>()
    }
    enum Action: Equatable, Sendable {
        case didTapNextButton
    }
    
    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action  {
            case .didTapNextButton:
                return .none
            }
        }
    }
    
    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable, Sendable {
            // TODO: there is a names completion screen before this.
            case onboardingCompleteScreen(OnboardingCompleteLogic.State = .init())
        }
        
        enum Action: Equatable, Sendable {
            case onboardingCompleteScreen(OnboardingCompleteLogic.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: \.onboardingCompleteScreen, action: \.onboardingCompleteScreen) {
                OnboardingCompleteLogic()
            }
        }
    }
}
