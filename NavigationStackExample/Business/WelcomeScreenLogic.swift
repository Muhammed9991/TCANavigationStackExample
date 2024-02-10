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
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .didTapNextButton:
                state.path.append(.yearOfBirthScreen())
                return .none
                
            case .path:
                return .none
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
        }
        
        enum Action: Equatable, Sendable {
            case yearOfBirthScreen(YearOfBirthLogic.Action)
        }
        
        var body: some Reducer<State, Action> {
            Scope(state: \.yearOfBirthScreen, action: \.yearOfBirthScreen) {
                YearOfBirthLogic()
            }
        }
    }
}
