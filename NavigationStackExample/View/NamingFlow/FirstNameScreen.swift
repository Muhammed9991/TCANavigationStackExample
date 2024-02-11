import SwiftUI
import ComposableArchitecture

struct FirstNameScreen: View {
    @Perception.Bindable var store: StoreOf<FirstNameScreenLogic>
    @FocusState var focusedField: FirstNameScreenLogic.State.Field?
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                
                VStack(alignment: .leading, spacing: 10) {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                        .frame(height: 40)
                        .overlay(
                            TextField("Type your first name:", text: self.$store.firstName)
                                .padding(.horizontal, 8)
                                .foregroundColor(.black)
                                .focused($focusedField, equals: .firstName)
                        )
                    
                }
                .padding()
                
                NextButton(buttonMode: self.$store.buttonMode) {
                    self.store.send(.didTapNextButton)
                }
            }
            .padding()
            .bind(self.$store.focusedField, to: self.$focusedField)
            .onAppear {
                self.store.send(.onAppear)
            }
            .navigationTitle("First name screen")
        }
    }
}

#Preview {
    FirstNameScreen(store: Store(initialState: FirstNameScreenLogic.State(), reducer: {
        FirstNameScreenLogic()
    }))
}
