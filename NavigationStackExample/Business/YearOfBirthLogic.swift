import Foundation
import ComposableArchitecture

@Reducer
struct YearOfBirthLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var path = StackState<Path.State>()
        var dateOfBirth: String = ""
    }
    
    enum Action: Equatable, Sendable, BindableAction {
        case binding(BindingAction<State>)
        case didTapNextButton
        case path(StackAction<Path.State, Path.Action>)
    }
    
    @Dependency(\.ageHelper) var ageHelper
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action {
                
            case .didTapNextButton:
                // TODO: handling under 18 first need to handle above 18 logic
                if !ageHelper.isUser18orAbove(dateOfBirth: state.dateOfBirth) {
                    state.path.append(.onboardingCompleteScreen())
                }
                return .none
                
            case .path, .binding:
                return .none
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
