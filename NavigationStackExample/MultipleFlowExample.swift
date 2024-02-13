import SwiftUI
import ComposableArchitecture

@main
struct NavigationStackExampleApp: App {
    @State private var isActive: Bool = false
    var body: some Scene {
        WindowGroup {
            ZStack {
                
                if isActive {
                    WelcomeScreen(store: Store(initialState: WelcomeScreenLogic.State(), reducer: {
                        WelcomeScreenLogic()
                    }))
                } else {
                    SplashScreen()
                }
                
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }

            }
        }
    }
}
