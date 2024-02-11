import SwiftUI
import ComposableArchitecture

struct NameCompleteScreen: View {
    let store: StoreOf<NameCompleteLogic>
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                
                Text("Your full name is")
                
                NextButton {
                    self.store.send(.didTapNextButton)
                }
            }
            .padding()
            .navigationTitle("Name complete screen")
        }
    }
}

#Preview {
    NameCompleteScreen(store: Store(initialState: NameCompleteLogic.State(), reducer: {
        NameCompleteLogic()
    }))
}
