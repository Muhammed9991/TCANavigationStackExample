import SwiftUI
import ComposableArchitecture
struct NamingFlowView: View {
    @Perception.Bindable var store: StoreOf<FirstNameScreenLogic>
    var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: self.$store.scope(state: \.path, action: \.path)) {
                FirstNameScreen(store: store)
            } destination: { store in
                switch store.state {
                case .familyNameScreen:
                    if let store = store.scope(state: \.familyNameScreen, action: \.familyNameScreen) {
                        FamilyNameScreen(store: store)
                    }
                    
                case .nameCompleteScreen:
                    if let store = store.scope(state: \.nameCompleteScreen, action: \.nameCompleteScreen) {
                        NameCompleteScreen(store: store)
                    }
                }
            }
        }
    }
}

