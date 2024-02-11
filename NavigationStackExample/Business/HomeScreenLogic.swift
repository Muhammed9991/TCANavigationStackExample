import Foundation
import ComposableArchitecture

@Reducer
struct HomeScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var fullName: String?
        var dateOfBirth: Date?
    }
    
    enum Action: Equatable, Sendable {
        case didTapNextButton
        case onAppear
    }
    
    @Dependency(\.onBoardingCache) var onBoardingCache
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
                
            case .onAppear:
                let model = onBoardingCache.value()
                state.fullName = model?.fullName
                state.dateOfBirth = model?.dateOfBirth
                return .none
            case .didTapNextButton:
                return .none
            }
        }
    }
}
