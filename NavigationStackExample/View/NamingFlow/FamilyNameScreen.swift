import SwiftUI
import ComposableArchitecture

struct FamilyNameScreen: View {
    let store: StoreOf<FamilyNameScreenLogic>
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                
                Text("Family name")
                
                NextButton {
                    self.store.send(.didTapNextButton)
                }
            }
            .padding()
            .navigationTitle("Family name screen")
        }
    }
}

#Preview {
    FamilyNameScreen(store: Store(initialState: FamilyNameScreenLogic.State(), reducer: {
        FamilyNameScreenLogic()
    }))
}
