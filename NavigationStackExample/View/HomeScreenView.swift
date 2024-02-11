import SwiftUI
import ComposableArchitecture

struct HomeScreenView: View {
    let store: StoreOf<HomeScreenLogic>
    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading) {
                
                Text("Summary:")
                    .font(.title)
                    .fontWeight(.bold)
                if let dateOfBirth = self.store.dateOfBirth {
                    Text("Date of birth: \(dateOfBirth.formatted(date: .long, time: .omitted))")
                }
                
                if let fullName = self.store.fullName {
                    Text("Full name: \(fullName)")
                }
            }
            .navigationBarBackButtonHidden()
            .navigationTitle("Welcome screen")
        }
    }
}

#Preview("Only DOB") {
    HomeScreenView(store: Store(initialState: HomeScreenLogic.State(dateOfBirth: .now), reducer: {
        HomeScreenLogic()
    }))
}

#Preview("DOB and Full name") {
    HomeScreenView(store: Store(initialState: HomeScreenLogic.State(fullName: "John Doe", dateOfBirth: .now), reducer: {
        HomeScreenLogic()
    }))
}
