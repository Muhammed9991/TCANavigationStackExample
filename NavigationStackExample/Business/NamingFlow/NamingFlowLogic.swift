import SwiftUI
import ComposableArchitecture

@Reducer
struct NamingFlowLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var path = StackState<Path.State>()
        var namingFlowStack: NamingFlowStack.State? = .firstNameScreen(FirstNameScreenLogic.State())
    }
    enum Action: Equatable, Sendable {
        case namingFlowStack(NamingFlowStack.Action)
        case onAppear
        case path(StackAction<Path.State, Path.Action>)
        case delegate(Delegate)
        enum Delegate: Equatable, Sendable {
            case navigateToFamilyNameScreen(firstName: String)
            case navigateToNameCompleteScreen(firstName: String, familyName: String)
            case finalNavigation(firstName: String, familyName: String)
        }
        
//        case navigateToFamilyNameScreen(OnboardingModel)
    }
    
    @Dependency(\.dataManager) var dataManager
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case let .namingFlowStack(.firstNameScreen(.delegate(.navigateToFamilyNameScreen(firstName: firstName)))):
                return .send(.delegate(.navigateToFamilyNameScreen(firstName: firstName)))
                
            case let .namingFlowStack(.familyNameScreen(.delegate(.navigateToNameCompleteScreen(firstName: firstName, familyName: familyName)))):
                return .send(.delegate(.navigateToNameCompleteScreen(firstName: firstName, familyName: familyName)))
                
            case let .namingFlowStack(.nameCompleteScreen(.delegate(.navigate(firstName: firstName, familyName: familyName)))):
                return .send(.delegate(.finalNavigation(firstName: firstName, familyName: familyName)))
            
            case .namingFlowStack, .delegate:
                return .none
                
            case let .path(action):
                switch action {
                case let .element(id: _, action: .firstNameScreen(.delegate(.navigateToFamilyNameScreen(firstName: firstName)))):
                    
//                    if dataManager.isDataAvailable(from: .onBoarding) {
//                        return .run { send in
//                            let model = try JSONDecoder().decode(OnboardingModel.self, from: dataManager.load(.onBoarding))
//                            await send(.navigateToFamilyNameScreen(model))
//                        }
//                    }
                    
                    return .none
                    
                default:
                    return .none
                }
                
//            case let .navigateToFamilyNameScreen(model):
//                guard let firstName = model.firstName, let familyName = model.familyName else {
//                    return .none
//                }
//                state.path.append(.familyNameScreen(FamilyNameScreenLogic.State(firstName: firstName, familyName: familyName)))
//                return .none
            }
        }
        .ifLet(\.namingFlowStack, action: \.namingFlowStack) {
            NamingFlowStack()
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
    
    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable, Sendable {
            case firstNameScreen(FirstNameScreenLogic.State)
            case familyNameScreen(FamilyNameScreenLogic.State)
            case nameCompleteScreen(NameCompleteLogic.State)

        }
        enum Action: Equatable, Sendable {
            case firstNameScreen(FirstNameScreenLogic.Action)
            case familyNameScreen(FamilyNameScreenLogic.Action)
            case nameCompleteScreen(NameCompleteLogic.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: \.firstNameScreen, action: \.firstNameScreen) {
                FirstNameScreenLogic()
            }
            Scope(state: \.familyNameScreen, action: \.familyNameScreen) {
                FamilyNameScreenLogic()
            }
            Scope(state: \.nameCompleteScreen, action: \.nameCompleteScreen) {
                NameCompleteLogic()
            }
        }
    }

}
