import SwiftUI

struct NextButton: View {
    @Binding var buttonMode: ButtonMode
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
                        .background(buttonMode == .disabled ? Color.gray : Color.blue)
                        .cornerRadius(10) // Adjust the corner radius as needed
                }
                .disabled(buttonMode == .disabled)
            }
        }
        .padding(.trailing)
    }
}


#Preview("Disabled") {
    NextButton(buttonMode: .constant(.disabled)) { }
}

#Preview("Enabled") {
    NextButton(buttonMode: .constant(.enabled)) { }
}
