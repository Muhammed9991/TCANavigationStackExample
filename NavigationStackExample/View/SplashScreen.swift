import SwiftUI

struct SplashScreen: View {
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(
                    gradient: Gradient(colors: [.red, .orange, .yellow, .green, .blue, .purple]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                        .overlay(content: {
                            Text("Splash screen")
                                .font(.title)
                                .foregroundStyle(Color.white)
                                .fontWeight(.bold)
                                .padding()
                        })
                )
                .ignoresSafeArea(.all)
            
           
        }
    }
}

#Preview {
    SplashScreen()
}
