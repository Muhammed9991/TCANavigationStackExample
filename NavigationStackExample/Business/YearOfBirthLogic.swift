import Foundation
import ComposableArchitecture

@Reducer
struct YearOfBirthLogic {
    @ObservableState
    struct State: Equatable, Sendable {
        
    }
    
    enum Action: Equatable, Sendable {
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
                
            }
        }
    }
}
