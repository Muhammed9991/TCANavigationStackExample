import Foundation
import ComposableArchitecture

@Reducer
struct YearOfBirthLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var dateOfBirth: Date = .now
    }
    
    enum Action: Equatable, Sendable, BindableAction {
        case binding(BindingAction<State>)
        case didTapNextButton(dateOfBirth: Date)
        case navigateToNamingFlow
        case navigateToOnBoardingCompleteScreen(dateOfBirth: Date)
    }
    
    @Dependency(\.ageHelper) var ageHelper
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action {
                
            case let .didTapNextButton(dateOfBirth: dateOfBirth):
                if ageHelper.isUser18orAbove(dateOfBirth: state.dateOfBirth.description ) {
                    return .send(.navigateToNamingFlow)
                } else {
                    return .send(.navigateToOnBoardingCompleteScreen(dateOfBirth: dateOfBirth))
                }
                
            case .navigateToNamingFlow:
                return .none
                
            case .navigateToOnBoardingCompleteScreen:
                return .none
                
            case .binding:
                return .none
            }
        }
    }
}
