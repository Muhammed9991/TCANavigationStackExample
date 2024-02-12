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
    
    @Dependency(\.dataManager.save) var saveData
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .run { [dateOfBirth = state.dateOfBirth,  fullName = state.fullName] send in
                    if let dateOfBirth {
                        let userData = OnboardingModel(fullName: fullName, dateOfBirth: dateOfBirth)
                        try await saveData(JSONEncoder().encode(userData), .onBoarding)
                    }
                }
            
            case .didTapNextButton:
                return .send(.navigateToHomeScreen)
                
            case .navigateToHomeScreen:
                return .none
            }
        }
    }
}
