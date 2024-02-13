import Foundation
import ComposableArchitecture

@Reducer
struct OnboardingCompleteLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var firstName: String?
        var familyName: String?
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
                return .run { [
                    dateOfBirth = state.dateOfBirth,
                    firstName = state.firstName,
                    familyName = state.familyName
                ] send in
                    if let dateOfBirth {
                        let namingModel = NamingModel(firstName: firstName, familyName: familyName)
                        let dobModel = DateOfBirthModel(dateOfBirth: dateOfBirth)
                        try await saveData(JSONEncoder().encode(namingModel), .namingModel)
                        try await saveData(JSONEncoder().encode(dobModel), .dobModel)
                    }
                } catch: { error, send in
                    // TODO: handle write error
                }
            
            case .didTapNextButton:
                return .send(.navigateToHomeScreen)
                
            case .navigateToHomeScreen:
                return .none
            }
        }
    }
}
