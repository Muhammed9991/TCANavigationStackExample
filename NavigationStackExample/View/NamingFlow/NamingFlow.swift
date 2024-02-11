import SwiftUI
import ComposableArchitecture

struct NamingFlow: View {
    let store: StoreOf<NamingFlowLogic>
    var body: some View {
        WithPerceptionTracking {
            VStack {
                if let childStore = store.scope(state: \.namingFlowStack, action: \.namingFlowStack) {
                    switch childStore.state {
                    case .firstNameScreen:
                        if let store = childStore.scope(state: \.firstNameScreen, action: \.firstNameScreen) {
                            FirstNameScreen(store: store)
                                .transition(.slide)
                        }
                    case .familyNameScreen:
                        Text("Family Name")
                            .transition(.slide)
                    case .nameCompleteScreen:
                        Text("Name Complete")
                            .transition(.slide)
                    }
                }
            }
            .onAppear {
                self.store.send(.onAppear)
            }
        }
    }
}

#Preview {
    NamingFlow(store: Store(initialState: NamingFlowLogic.State(), reducer: {
        NamingFlowLogic()
    }))
}


@Reducer
struct NamingFlowLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var namingFlowStack: NamingFlowStack.State? = .firstNameScreen(FirstNameScreenLogic.State())
    }
    enum Action: Equatable, Sendable {
        case namingFlowStack(NamingFlowStack.Action)
        case onAppear
        case delegate(Delegate)
        enum Delegate: Equatable, Sendable {
            case navigateToFamilyNameScreen
            case navigateToNameCompleteScreen
            case finalNavigation
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .onAppear:
                return .none
                
            case .namingFlowStack(.firstNameScreen(.delegate(.navigateToFamilyNameScreen))):
                return .send(.delegate(.navigateToFamilyNameScreen))
                
            case .namingFlowStack(.familyNameScreen(.delegate(.navigateToNameCompleteScreen))):
                return .send(.delegate(.navigateToNameCompleteScreen))
                
            case .namingFlowStack(.nameCompleteScreen(.delegate(.navigate))):
                return .send(.delegate(.finalNavigation))
            
            case .namingFlowStack, .delegate:
                return .none
            }
        }
        .ifLet(\.namingFlowStack, action: \.namingFlowStack) {
            NamingFlowStack()
        }
    }
}
