@testable import NavigationStackExample
import XCTest
import ComposableArchitecture

@MainActor
final class WelcomeScreenLogicTests: XCTestCase {
    
    func testOnAppearWhenUserLoggedOut() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State()) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager.isDataAvailable = { _ in false }
        }
        
        await store.send(.onAppear)
    }
    
    func testOnAppearWhenUserLoggedIn() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State()) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager.isDataAvailable = { _ in true }
        }
        
        await store.send(.onAppear) {
            $0.path[id: 0] = .homeScreen(HomeScreenLogic.State())
        }
    }
    
    func testNavigateToHomeScreen() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State()) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager = .mock()
        }
        
        await store.send(.navigateToHomeScreen(firstName: "John", familyName: "Doe")) {
            $0.path[id: 0] = .homeScreen(HomeScreenLogic.State(fullName: "John Doe"))
        }
    }
    
    // MARK: - Homes screen navigation tests
    func testHomeScreenLogOutButtonTapped() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State(
            path: StackState(
                [
                    .homeScreen(HomeScreenLogic.State())
                ]
            )
        )) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager = .mock()
        }
        
        await store.send(.path(.element(id: 0, action: .homeScreen(.delegate(.logOut))))){
            $0.path[id: 0] = nil
        }
    }
    
    // MARK: - Year of birth screen  navigation tests
    func testYearOfBirthScreenNavigateToNamingFlow() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State(
            path: StackState(
                [
                    .yearOfBirthScreen(YearOfBirthLogic.State())
                ]
            )
        )) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager = .mock()
        }
        
        await store.send(.path(.element(id: 0, action: .yearOfBirthScreen(.navigateToNamingFlow)))) {
            $0.path[id: 1] = .namingFlow(NamingFlowLogic.State())
        }
    }
    
    func testYearOfBirthScreenDidTapNextButton() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State(
            path: StackState(
                [
                    .yearOfBirthScreen(YearOfBirthLogic.State())
                ]
            )
        )) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager = .mock()
            $0.date.now = Date(timeIntervalSince1970: 12345678)
            $0.ageHelper.isUser18orAbove = { _ in true }
        }
        
        store.exhaustivity = .off
        await store.send(.path(.element(id: 0, action: .yearOfBirthScreen(.didTapNextButton(dateOfBirth: Date(timeIntervalSince1970: 12345678)))))) {
            $0.dateOfBirth = Date(timeIntervalSince1970: 12345678)
        }
    }
    
    func testYearOfBirthScreenNavigateToOnBoardingCompleteScreen() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State(
            path: StackState(
                [
                    .yearOfBirthScreen(YearOfBirthLogic.State())
                ]
            )
        )) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager = .mock()
        }
        
        await store.send(.path(.element(id: 0, action: .yearOfBirthScreen(.navigateToOnBoardingCompleteScreen(dateOfBirth: Date(timeIntervalSince1970: 12345678)))))) {
            $0.dateOfBirth = Date(timeIntervalSince1970: 12345678)
            $0.path[id: 1] = .onboardingCompleteScreen(OnboardingCompleteLogic.State(dateOfBirth: Date(timeIntervalSince1970: 12345678)))
        }
    }
    
    // MARK: - Naming flow navigation tests
    func testNamingFlowOnAppear() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State(
            path: StackState(
                [
                    .namingFlow(NamingFlowLogic.State())
                ]
            )
        )) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager = .mock()
        }
        
        await store.send(.path(.element(id: 0, action: .namingFlow(.onAppear)))) {
            $0.path[id: 1] = .namingFlow(.init(namingFlowStack: .firstNameScreen(FirstNameScreenLogic.State())))
        }
    }
    
    func testNamingFlowNavigateToFamilyNameScreen() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State(
            path: StackState(
                [
                    .namingFlow(NamingFlowLogic.State())
                ]
            )
        )) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager = .mock()
        }
        
        await store.send(.path(.element(id: 0, action: .namingFlow(.delegate(.navigateToFamilyNameScreen(firstName: "John")))))) {
            $0.path[id: 1] = .namingFlow(.init(namingFlowStack: .familyNameScreen(FamilyNameScreenLogic.State(firstName: "John"))))
        }
    }
    
    func testNamingFlowNavigateToNameCompeteScreen() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State(
            path: StackState(
                [
                    .namingFlow(NamingFlowLogic.State())
                ]
            )
        )) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager = .mock()
        }
        
        await store.send(.path(.element(id: 0, action: .namingFlow(.delegate(.navigateToNameCompleteScreen(firstName: "John", familyName: "Doe")))))) {
            $0.path[id: 1] = .namingFlow(.init(namingFlowStack: .nameCompleteScreen(NameCompleteLogic.State(firstName: "John", familyName: "Doe"))))
        }
    }
    
    func testNamingFlowFinalNavigationWhenUserLoggedOut() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State(
            path: StackState(
                [
                    .namingFlow(NamingFlowLogic.State())
                ]
            )
            , dateOfBirth: Date(timeIntervalSince1970: 12345678)
        )) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager.isDataAvailable = {_ in false}
        }
        
        await store.send(.path(.element(id: 0, action: .namingFlow(.delegate(.finalNavigation(firstName: "John", familyName: "Doe")))))) {
            $0.path[id: 1] = .onboardingCompleteScreen(OnboardingCompleteLogic.State(firstName: "John", familyName: "Doe", dateOfBirth: Date(timeIntervalSince1970: 12345678)))
        }
    }
    
    func testNamingFlowFinalNavigationWhenUserLoggedIn() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State(
            path: StackState(
                [
                    .namingFlow(NamingFlowLogic.State())
                ]
            )
            , dateOfBirth: Date(timeIntervalSince1970: 12345678)
        )) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager.isDataAvailable = {_ in true}
            $0.dataManager.save = { _, _ in  }
        }
        
        await store.send(.path(.element(id: 0, action: .namingFlow(.delegate(.finalNavigation(firstName: "John", familyName: "Doe"))))))
        
        await store.receive(.navigateToHomeScreen(firstName: "John", familyName: "Doe")) {
            $0.path[id: 1] = .homeScreen(HomeScreenLogic.State(fullName: "John Doe"))
        }
    }
    
    func testNamingFlowFinalNavigationWhenUserLoggedInFailedToSaveData() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State(
            path: StackState(
                [
                    .namingFlow(NamingFlowLogic.State())
                ]
            )
            , dateOfBirth: Date(timeIntervalSince1970: 12345678)
        )) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager = .failToWrite
        }
        
        await store.send(.path(.element(id: 0, action: .namingFlow(.delegate(.finalNavigation(firstName: "John", familyName: "Doe"))))))
        
        // TODO: handle if fail to save data
    }
    
    // MARK: Onboarding complete navigation
    
    func testOnboardingCompleteNavigateToHomeScreen() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State(
            path: StackState(
                [
                    .onboardingCompleteScreen(OnboardingCompleteLogic.State())
                ]
            )
        )) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager = .mock()
        }
        
        await store.send(.path(.element(id: 0, action: .onboardingCompleteScreen(.navigateToHomeScreen)))) {
            $0.path[id: 1] = .homeScreen(HomeScreenLogic.State())
        }
    }
    
    // MARK: Home screen  navigation to naming flow
    func testHomeScreenDidTapUpdateNameButton() async {
        let store = TestStore(initialState: WelcomeScreenLogic.State(
            path: StackState(
                [
                    .homeScreen(HomeScreenLogic.State())
                ]
            )
        )) {
            WelcomeScreenLogic()
        } withDependencies: {
            $0.dataManager = .mock()
        }
        
        await store.send(.path(.element(id: 0, action: .homeScreen(.didTapUpdateNameButton)))) {
            $0.path[id: 1] = .namingFlow(NamingFlowLogic.State())
        }
    }
}
