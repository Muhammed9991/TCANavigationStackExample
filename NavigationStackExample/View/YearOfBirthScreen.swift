import SwiftUI
import ComposableArchitecture

struct YearOfBirthScreen: View {
    @Perception.Bindable var store: StoreOf<YearOfBirthLogic>
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                DatePicker(selection: self.$store.dateOfBirth, in: ...Date.now, displayedComponents: .date) {
                    Text("Choose your date of birth")
                }
                
                NextButton(buttonMode: .constant(.enabled)) {
                    self.store.send(.didTapNextButton(dateOfBirth: self.store.dateOfBirth))
                }
            }
            .padding()
            .navigationTitle("Year of birth")
        }
    }
}

#Preview {
    YearOfBirthScreen(store: Store(initialState: YearOfBirthLogic.State(), reducer: {
        YearOfBirthLogic()
    }))
}
