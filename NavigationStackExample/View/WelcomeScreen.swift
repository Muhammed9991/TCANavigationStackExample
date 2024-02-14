import SwiftUI
import ComposableArchitecture

struct WelcomeScreen: View {
    @Perception.Bindable var store: StoreOf<WelcomeScreenLogic>
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                ZStack {
                    Text("Welcome ")
                    NextButton(buttonMode: .constant(.enabled)) {
                        self.store.send(.didTapNextButton)
                    }
                }
                .onAppear { self.store.send(.onAppear) }
            } destination: { store in
                switch store.case {
                case let .yearOfBirthScreen(store):
                        YearOfBirthScreen(store: store)
                case let .onboardingCompleteScreen(store):
                        OnboardingCompleteScreen(store: store)
                    
                case let .homeScreen(store):
                        HomeScreenView(store: store)
                    
                case let .namingFlow(store):
                    
                    WithPerceptionTracking {
                        if let childStore = store.scope(state: \.namingFlowStack, action: \.namingFlowStack) {
                            switch childStore.state {
                            case .firstNameScreen:
                                if let store = childStore.scope(state: \.firstNameScreen, action: \.firstNameScreen) {
                                    FirstNameScreen(store: store)
                                }
                            case .familyNameScreen:
                                if let store = childStore.scope(state: \.familyNameScreen, action: \.familyNameScreen) {
                                    FamilyNameScreen(store: store)
                                }
                                
                            case .nameCompleteScreen:
                                if let store = childStore.scope(state: \.nameCompleteScreen, action: \.nameCompleteScreen) {
                                    NameCompleteScreen(store: store)
                                }
                            }
                        }
                    }
                    
                }
            }
        }
    }
}

#Preview {
    WelcomeScreen(store: Store(initialState: WelcomeScreenLogic.State(), reducer: {
        WelcomeScreenLogic()
    }))
}
