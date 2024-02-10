import Foundation
import ComposableArchitecture

@Reducer
struct FirstNameScreenLogic {
    struct State: Equatable, Sendable {
        var path = StackState<Path.State>()
    }
    enum Action: Equatable, Sendable {
        case didTapNextButton
    }
    
    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action  {
            case .didTapNextButton:
                state.path.append(.familyNameScreen())
                return .none
            }
        }
    }
    
    @Reducer
    struct Path {
        @ObservableState
        enum State: Equatable, Sendable {
            case familyNameScreen(FamilyNameScreenLogic.State = .init())
        }
        
        enum Action: Equatable, Sendable {
            case familyNameScreen(FamilyNameScreenLogic.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: \.familyNameScreen, action: \.familyNameScreen) {
                FamilyNameScreenLogic()
            }
        }
    }
}
