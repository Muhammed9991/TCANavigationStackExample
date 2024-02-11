import Foundation

import Foundation
import ComposableArchitecture

@Reducer
struct NamingFlowStack {
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
        Reduce { state, action in
            switch action {
            case .firstNameScreen, .familyNameScreen, .nameCompleteScreen:
                return .none
            }
        }
        .ifCaseLet(\.firstNameScreen, action: \.firstNameScreen) {
            FirstNameScreenLogic()
        }
        .ifCaseLet(\.familyNameScreen, action: \.familyNameScreen) {
            FamilyNameScreenLogic()
        }
        .ifCaseLet(\.nameCompleteScreen, action: \.nameCompleteScreen) {
            NameCompleteLogic()
        }
    }
}
