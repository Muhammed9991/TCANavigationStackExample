import Foundation
import ComposableArchitecture

@Reducer
struct HomeScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var fullName: String?
        var dateOfBirth: Date?
        init(fullName: String? = nil, dateOfBirth: Date? = nil) {
            self.fullName = fullName
            self.dateOfBirth = dateOfBirth
            
            do {
                @Dependency(\.dataManager.load) var loadData
                let model = try JSONDecoder().decode(OnboardingModel.self, from: loadData(.onBoarding))
                self.fullName = model.fullName
                self.dateOfBirth = model.dateOfBirth
            } catch {
                // TODO: handle error. This technically not possible.
            }
            
        }
    }
    
    enum Action: Equatable, Sendable {
        case didTapLogOutButton
        case delegate(Delegate)
        enum Delegate: Equatable, Sendable {
            case logOut
        }
    }
       
    @Dependency(\.dataManager.delete) var delete
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .didTapLogOutButton:
                return .run { send in
                    try await delete(.onBoarding)
                    await send(.delegate(.logOut))
                }
                
            case .delegate(.logOut):
                return .none
            }
        }
    }
}
