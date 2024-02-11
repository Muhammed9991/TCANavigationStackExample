import SwiftUI
import ComposableArchitecture

struct OnboardingCompleteScreen: View {
    let store: StoreOf<OnboardingCompleteLogic>
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                Text("WOOOOHOOOO! Onboarding complete")
                
                NextButton(buttonMode: .constant(.enabled)) {
                    self.store.send(.didTapNextButton)
                }
            }
            .onAppear {
                self.store.send(.onAppear)
            }
            .navigationTitle("Onboarding complete")
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    OnboardingCompleteScreen(store: Store(initialState: OnboardingCompleteLogic.State(), reducer: {
        OnboardingCompleteLogic()
    }))
}
