import SwiftUI
import ComposableArchitecture

@main
struct NavigationStackExampleApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeScreen(store: Store(initialState: WelcomeScreenLogic.State(), reducer: {
                WelcomeScreenLogic()
            }))
        }
    }
}
