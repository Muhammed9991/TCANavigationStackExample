import Foundation
import ComposableArchitecture

@Reducer
struct WelcomeScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var path = StackState<Path.State>()
        var dateOfBirth: Date?
    }
    enum Action: Equatable, Sendable {
        case didTapNextButton
        case onAppear
        case path(StackAction<Path.State, Path.Action>)
    }
    
    @Dependency(\.ageHelper) var ageHelper
    @Dependency(\.onBoardingCache) var onBoardingCache
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                let onBoardingCache = onBoardingCache.value()
                let isUserLoggedIn = onBoardingCache != nil
                
                if isUserLoggedIn {
                    state.path.append(.homeScreen(HomeScreenLogic.State()))
                }
                
                return .none
            
            case .didTapNextButton:
                state.path.append(.yearOfBirthScreen())
                return .none
                
            case let .path(action):
                switch action {
                case .element(id: _, action: .yearOfBirthScreen(.navigateToNamingFlow)):
                    state.path.append(.namingFlow())
                    return .none
                    
                case let.element(id: _, action: .yearOfBirthScreen(.didTapNextButton(dateOfBirth: dateOfBirth))):
                    state.dateOfBirth = dateOfBirth
                    return .none
                    
                case let .element(id: _, action: .yearOfBirthScreen(.navigateToOnBoardingCompleteScreen(dateOfBirth: dateOfBirth))):
                    state.dateOfBirth = dateOfBirth
                    state.path.append(.onboardingCompleteScreen(.init(dateOfBirth: dateOfBirth)))
                    return .none
                    
                case .element(id: _, action: .namingFlow(.onAppear)):
                    state.path.append(
                        .namingFlow(
                            .init(
                                namingFlowStack: .firstNameScreen(FirstNameScreenLogic.State())
                                 )
                        )
                    )
                    return .none
                    
                case let .element(id: _, action: .namingFlow(.delegate(.navigateToFamilyNameScreen(firstName: firstName)))):
                    state.path.append(
                        .namingFlow(
                            .init(
                                namingFlowStack: .familyNameScreen(FamilyNameScreenLogic.State(firstName: firstName))
                            )
                        )
                    )
                    return .none
                    
                case let .element(id: _, action: .namingFlow(.delegate(.navigateToNameCompleteScreen(fullName: fullName)))):
                    state.path.append(
                        .namingFlow(
                            .init(
                                namingFlowStack: .nameCompleteScreen(NameCompleteLogic.State(fullName: fullName))
                            )
                        )
                    )
                    return .none
                    
                case let .element(id: _, action: .namingFlow(.delegate(.finalNavigation(fullName: fullName)))):
                    state.path.append(.onboardingCompleteScreen(OnboardingCompleteLogic.State(fullName: fullName, dateOfBirth: state.dateOfBirth)))
                    return .none
                    
                case .element(id: _, action: .onboardingCompleteScreen(.navigateToHomeScreen)):
                    state.path.append(.homeScreen(HomeScreenLogic.State()))
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
            case namingFlow(NamingFlowLogic.State = .init())
            case homeScreen(HomeScreenLogic.State = .init())
            
        }
        
        enum Action: Equatable, Sendable {
            case yearOfBirthScreen(YearOfBirthLogic.Action)
            case onboardingCompleteScreen(OnboardingCompleteLogic.Action)
            case namingFlow(NamingFlowLogic.Action)
            case homeScreen(HomeScreenLogic.Action)
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
            Scope(state: \.homeScreen, action: \.homeScreen) {
                HomeScreenLogic()
            }
        }
    }
}
