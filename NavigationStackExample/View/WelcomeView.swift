import SwiftUI
import ComposableArchitecture

struct WelcomeView: View {
    @Perception.Bindable var store: StoreOf <WelcomeScreenLogic>
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
                ZStack {
                    Text("Welcome ")
                    
                    
                    NextButton {
                        self.store.send(.didTapNextButton)
                    }
                }
            } destination: { store in
                switch store.state {
                case .yearOfBirthScreen:
                    if let store = store.scope(state: \.yearOfBirthScreen, action: \.yearOfBirthScreen) {
                        YearOfBirthScreen(store: store)
                    }
                case .onboardingCompleteScreen:
                    if let store = store.scope(state: \.onboardingCompleteScreen, action: \.onboardingCompleteScreen) {
                        OnboardingCompleteScreen(store: store)
                    }
                case .namingFlow:
                    if let store = store.scope(state: \.namingFlow, action: \.namingFlow) {
                        
                    }
                }
            }
        }
    }
}

#Preview {
    WelcomeView(store: Store(initialState: WelcomeScreenLogic.State(), reducer: {
        WelcomeScreenLogic()
    }))
}

struct NextButton: View {
    let onButtonTapped: () -> Void
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
               
                Button {
                    onButtonTapped()
                } label: {
                    Text("Next")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10) // Adjust the corner radius as needed
                }
            }
        }
        .padding(.trailing)
    }
}
