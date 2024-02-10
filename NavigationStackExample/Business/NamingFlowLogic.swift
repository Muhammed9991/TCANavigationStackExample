import Foundation

import Foundation
import ComposableArchitecture

@Reducer
struct NamingFlowLogic {
    @ObservableState
    enum State: Equatable, Sendable {
        case firstNameScreen(FirstNameScreenLogic.State)

    }
    enum Action: Equatable, Sendable {
        case firstNameScreen(FirstNameScreenLogic.Action)
    }
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .firstNameScreen:
                return .none
            }
        }
        .ifCaseLet(\.firstNameScreen, action: \.firstNameScreen) {
            FirstNameScreenLogic()
        }
    }
}
