import SwiftUI
import ComposableArchitecture

struct NameCompleteScreen: View {
    let store: StoreOf<NameCompleteLogic>
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                
                VStack {
                    Text("Your full name is")
                    Text(self.store.fullName)
                }
                
                NextButton(buttonMode: .constant(.enabled)) {
                    self.store.send(.didTapNextButton)
                }
            }
            .padding()
            .navigationBarBackButtonHidden()
            .navigationTitle("Name complete screen")
        }
    }
}

#Preview {
    NameCompleteScreen(store: Store(initialState: NameCompleteLogic.State(firstName: "John", familyName: "Doe"), reducer: {
        NameCompleteLogic()
    }))
}
