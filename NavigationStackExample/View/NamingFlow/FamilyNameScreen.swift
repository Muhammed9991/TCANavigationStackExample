import SwiftUI
import ComposableArchitecture

struct FamilyNameScreen: View {
    @Perception.Bindable var store: StoreOf<FamilyNameScreenLogic>
    @FocusState var focusedField: FamilyNameScreenLogic.State.Field?
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                
                VStack(alignment: .leading, spacing: 10) {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.blue, lineWidth: 1)
                        .frame(height: 40)
                        .overlay(
                            TextField("Type your family name:", text: self.$store.lastName)
                                .padding(.horizontal, 8)
                                .foregroundColor(.black)
                                .focused($focusedField, equals: .lastName)
                        )
                    
                }
                .padding()
                
                NextButton(buttonMode: self.$store.buttonMode) {
                    self.store.send(.didTapNextButton)
                }
            }
            .onAppear {
                self.store.send(.onAppear)
            }
            .padding()
            .bind(self.$store.focusedField, to: self.$focusedField)
            .onAppear {
                self.store.send(.onAppear)
            }
            .navigationTitle("Family name screen")
        }
    }
}

#Preview {
    FamilyNameScreen(store: Store(initialState: FamilyNameScreenLogic.State(firstName: ""), reducer: {
        FamilyNameScreenLogic()
    }))
}
