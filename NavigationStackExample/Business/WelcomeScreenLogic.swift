import ComposableArchitecture

@Reducer
struct WelcomeScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var path = StackState<Path.State>()
    }
    enum Action: Equatable, Sendable {
        case didTapNextButton
        case path(StackAction<Path.State, Path.Action>)
    }
    
    @Dependency(\.ageHelper) var ageHelper
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .didTapNextButton:
                state.path.append(.yearOfBirthScreen())
                return .none
                
            case let .path(action):
                switch action {
                case .element(id: _, action: .yearOfBirthScreen(.navigateToNamingFlow)):
                    state.path.append(.namingFlow())
                    return .none
                    
                case .element(id: _, action: .yearOfBirthScreen(.navigateToOnBoardingCompleteScreen)):
                    state.path.append(.onboardingCompleteScreen())
                    return .none
                    
                default:
                    return .none
                }
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
            case yearOfBirthScreen(YearOfBirthLogic.State = .init())
            case onboardingCompleteScreen(OnboardingCompleteLogic.State = .init())
            case namingFlow(NamingFlowLogic.State = .firstNameScreen(FirstNameScreenLogic.State()))
            
        }
        
        enum Action: Equatable, Sendable {
            case yearOfBirthScreen(YearOfBirthLogic.Action)
            case onboardingCompleteScreen(OnboardingCompleteLogic.Action)
            case namingFlow(NamingFlowLogic.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: \.yearOfBirthScreen, action: \.yearOfBirthScreen) {
                YearOfBirthLogic()
            }
            Scope(state: \.onboardingCompleteScreen, action: \.onboardingCompleteScreen) {
                OnboardingCompleteLogic()
            }
            Scope(state: \.namingFlow, action: \.namingFlow) {
                NamingFlowLogic()
            }
        }
    }
}
