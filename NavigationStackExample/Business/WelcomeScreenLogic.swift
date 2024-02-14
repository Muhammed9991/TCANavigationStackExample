import Foundation
import ComposableArchitecture

@Reducer
struct WelcomeScreenLogic {
    
    @Reducer(state: .equatable, action: .equatable)
    enum Path {
        case yearOfBirthScreen(YearOfBirthLogic)
        case onboardingCompleteScreen(OnboardingCompleteLogic)
        case namingFlow(NamingFlowLogic)
        case homeScreen(HomeScreenLogic)
    }
    
    @ObservableState
    struct State: Equatable, Sendable {
        var path = StackState<Path.State>()
        var dateOfBirth: Date?
    }
    enum Action: Equatable, Sendable {
        case didTapNextButton
        case onAppear
        case path(StackAction<Path.State, Path.Action>)
        case navigateToHomeScreen(firstName: String, familyName: String)
    }
    
    @Dependency(\.ageHelper) var ageHelper
    @Dependency(\.dataManager.isDataAvailable) var isDataAvailable
    @Dependency(\.dataManager.save) var saveData
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                if isDataAvailable(.dobModel) || isDataAvailable(.namingModel) {
                    state.path.append(.homeScreen(HomeScreenLogic.State()))
                }
                
                return .none
                
            case let .navigateToHomeScreen(firstName: firstName, familyName: familyName):
                state.path.append(.homeScreen(HomeScreenLogic.State(fullName: "\(firstName) \(familyName)")))
                return .none
            
            case .didTapNextButton:
                state.path.append(.yearOfBirthScreen(YearOfBirthLogic.State()))
                return .none
                
            case let .path(action):
                switch action {
                case .element(id: _, action: .homeScreen(.delegate(.logOut))):
                    state.path.removeAll()
                    return .none
                    
                case .element(id: _, action: .yearOfBirthScreen(.navigateToNamingFlow)):
                    state.path.append(.namingFlow(NamingFlowLogic.State()))
                    return .none
                    
                case let.element(id: _, action: .yearOfBirthScreen(.didTapNextButton(dateOfBirth: dateOfBirth))):
                    state.dateOfBirth = dateOfBirth
                    return .none
                    
                case let .element(id: _, action: .yearOfBirthScreen(.navigateToOnBoardingCompleteScreen(dateOfBirth: dateOfBirth))):
                    state.dateOfBirth = dateOfBirth
                    state.path.append(.onboardingCompleteScreen(.init(dateOfBirth: dateOfBirth)))
                    return .none
                    
                case let .element(id: _, action: .namingFlow(namingFlowAction)):
                    switch namingFlowAction {
                    case .onAppear:
                        state.path.append(
                            .namingFlow(
                                .init(
                                    namingFlowStack: .firstNameScreen(FirstNameScreenLogic.State())
                                     )
                            )
                        )
                        return .none
                        
                    case let .delegate(.navigateToFamilyNameScreen(firstName: firstName)):
                        state.path.append(
                            .namingFlow(
                                .init(
                                    namingFlowStack: .familyNameScreen(FamilyNameScreenLogic.State(firstName: firstName))
                                )
                            )
                        )
                        return .none
                    
                    case let .delegate(.navigateToNameCompleteScreen(firstName: firstName, familyName: familyName)):
                        
                        state.path.append(
                            .namingFlow(
                                .init(
                                    namingFlowStack: .nameCompleteScreen(NameCompleteLogic.State(firstName: firstName, familyName: familyName))
                                )
                            )
                        )
                        
                        return .none
                        
                    case let .delegate(.finalNavigation(firstName: firstName, familyName: familyName)):
                        
                        if isDataAvailable(.namingModel) {
                            let namingModel = NamingModel(firstName: firstName, familyName: familyName)
                            
                            return .run { send in
                                try await saveData(JSONEncoder().encode(namingModel), .namingModel)
                                await send(.navigateToHomeScreen(firstName: firstName, familyName: familyName))
                            } catch: { error, send in
                                // TODO: handle error saving
                            }
                        } else {
                            state.path.append(.onboardingCompleteScreen(OnboardingCompleteLogic.State(firstName: firstName, familyName: familyName, dateOfBirth: state.dateOfBirth)))
                        }
                        return .none
                    default:
                        return .none
                    }
                    
                case .element(id: _, action: .onboardingCompleteScreen(.navigateToHomeScreen)):
                    state.path.append(.homeScreen(HomeScreenLogic.State()))
                    return .none
                    
                case .element(id: _, action: .homeScreen(.didTapUpdateNameButton)):
                    state.path.append(.namingFlow(NamingFlowLogic.State()))
                    return .none
                    
                    
                default:
                    return .none
                }
                
                
            }
        }
        .forEach(\.path, action: \.path)
    }
    
}
