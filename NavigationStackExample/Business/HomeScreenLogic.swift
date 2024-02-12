import Foundation
import ComposableArchitecture

@Reducer
struct HomeScreenLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        var fullName: String?
        var dateOfBirth: Date?
        @Presents var namingFlow: FirstNameScreenLogic.State?
    }
    
    @Dependency(\.dataManager.load) var loadData
    
    enum Action: Equatable, Sendable, BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case updateData(NamingModel, DateOfBirthModel)
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
                
            case .onAppear:
                return .run { send in
                    let namingModel = try JSONDecoder().decode(NamingModel.self, from: load(.namingModel))
                    let dobModel = try JSONDecoder().decode(DateOfBirthModel.self, from: load(.dobModel))
                    await send(.updateData(namingModel, dobModel))
                } catch: { error, send in
                    // TODO: Handle error
                }
                
            case let .updateData(namingModel, dobModel):
                if let firstName = namingModel.firstName, let familyName = namingModel.familyName {
                    let fullName = "\(firstName) \(familyName)"
                    state.fullName = fullName
                }
                state.dateOfBirth = dobModel.dateOfBirth
                return .none
            case .didTapLogOutButton:
                return .run { send in
                    try await delete(.namingModel)
                    try await delete(.dobModel)
                    await send(.delegate(.logOut))
                }
                
            case .didTapUpdateNameButton:
                state.namingFlow = FirstNameScreenLogic.State()
                return .none
                
            case .delegate(.logOut):
                return .none
                
            case .namingFlow, .binding:
                return .none
            }
        }
        .ifLet(\.$namingFlow, action: \.namingFlow) {
          FirstNameScreenLogic()
        }

    }
}
