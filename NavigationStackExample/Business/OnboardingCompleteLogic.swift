import Foundation
import ComposableArchitecture

@Reducer
struct OnboardingCompleteLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var fullName: String?
        var dateOfBirth: Date?
    }
    
    enum Action: Equatable, Sendable {
        case didTapNextButton
        case navigateToHomeScreen
        case onAppear
    }
    
    @Dependency(\.onBoardingCache) var onBoardingCache
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                // Save to cache
                if let dateOfBirth = state.dateOfBirth {
                    let fullName = state.fullName
                    let userData = OnboardingCacheModel(fullName: fullName, dateOfBirth: dateOfBirth)
                    onBoardingCache.insert(value: userData)
                }

                return .none
            
            case .didTapNextButton:
                return .send(.navigateToHomeScreen)
                
            case .navigateToHomeScreen:
                return .none
            }
        }
    }
}
