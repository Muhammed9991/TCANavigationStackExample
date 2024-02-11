import SwiftUI
import ComposableArchitecture

@main
struct NavigationStackExampleApp: App {
    var body: some Scene {
        WindowGroup {
            WelcomeView(store: Store(initialState: WelcomeScreenLogic.State(), reducer: {
                WelcomeScreenLogic()
            }))
        }
    }
}
