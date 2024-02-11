import SwiftUI
import ComposableArchitecture

struct FirstNameScreen: View {
    let store: StoreOf<FirstNameScreenLogic>
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                
                Text("First name")
                
                NextButton {
                    self.store.send(.didTapNextButton)
                }
            }
            .padding()
            .navigationTitle("First name screen")
        }
    }
}

#Preview {
    FirstNameScreen(store: Store(initialState: FirstNameScreenLogic.State(), reducer: {
        FirstNameScreenLogic()
    }))
}
