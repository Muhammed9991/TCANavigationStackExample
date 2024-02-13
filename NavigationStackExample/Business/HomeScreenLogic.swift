import Foundation
import ComposableArchitecture

@Reducer
struct HomeScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var fullName: String?
        var dateOfBirth: Date?
        
        init(
            fullName: String? = nil,
            dateOfBirth: Date? = nil
        ) {
            self.fullName = fullName
            self.dateOfBirth = dateOfBirth
            
            do {
                @Dependency(\.dataManager.load) var loadData
                let namingModel = try JSONDecoder().decode(NamingModel.self, from: loadData(.namingModel))
                
                if let firstName = namingModel.firstName, let familyName = namingModel.familyName {
                    let fullName = "\(firstName) \(familyName)"
                    self.fullName = fullName
                }
                
                let dobModel = try JSONDecoder().decode(DateOfBirthModel.self, from: loadData(.dobModel))
                self.dateOfBirth = dobModel.dateOfBirth
            } catch {
                // TODO: handle error. This technically not possible.
            }
            
        }
    }
    
    
    enum Action: Equatable, Sendable, BindableAction {
        case binding(BindingAction<State>)
        case didTapLogOutButton
        case didTapUpdateNameButton
        case namingFlow(PresentationAction<FirstNameScreenLogic.Action>)
        case delegate(Delegate)
        enum Delegate: Equatable, Sendable {
            case logOut
        }
    }
    
    @Dependency(\.dataManager.delete) var delete
    @Dependency(\.dataManager.load) var load
    
    var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action {
                
            case .didTapLogOutButton:
                return .run { send in
                    try await delete(.namingModel)
                    try await delete(.dobModel)
                    await send(.delegate(.logOut))
                }
                
            case .didTapUpdateNameButton:
                return .none
                
            case .delegate(.logOut):
                return .none
                
            case .namingFlow, .binding:
                return .none
            }
        }

    }
}
