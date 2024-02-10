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
                if ageHelper.isUser18orAbove(dateOfBirth: state.dateOfBirth) {
                    state.path.append(.namingFlow())
                } else {
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
            case namingFlow(NamingFlowLogic.State = .firstNameScreen(FirstNameScreenLogic.State()))
        }
        
        enum Action: Equatable, Sendable {
            case onboardingCompleteScreen(OnboardingCompleteLogic.Action)
            case namingFlow(NamingFlowLogic.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: \.onboardingCompleteScreen, action: \.onboardingCompleteScreen) {
                OnboardingCompleteLogic()
            }
            Scope(state: \.namingFlow, action: \.namingFlow) {
                NamingFlowLogic()
            }
        }
    }

}
