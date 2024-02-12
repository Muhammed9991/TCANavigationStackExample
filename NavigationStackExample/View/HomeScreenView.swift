import SwiftUI
import ComposableArchitecture

struct HomeScreenView: View {
    @Perception.Bindable var store: StoreOf<HomeScreenLogic>
    var body: some View {
        WithPerceptionTracking {
            ZStack {
                
                if self.store.fullName != nil {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                self.store.send(.didTapUpdateNameButton)
                            } label: {
                                Text("Update Name")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        Spacer()
                    }
                    .padding(.trailing)
                }
                
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
                
                VStack {
                    Spacer()
                    Button {
                        self.store.send(.didTapLogOutButton)
                    } label: {
                        Text("Log out")
                    }
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
