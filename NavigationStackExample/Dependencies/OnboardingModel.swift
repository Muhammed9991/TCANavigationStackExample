import Foundation
import Dependencies
import DependenciesMacros

final class OnboardingModel: Codable {
    let fullName: String?
    let dateOfBirth: Date?
    
    init(fullName: String?, dateOfBirth: Date?) {
        self.fullName = fullName
        self.dateOfBirth = dateOfBirth
    }
}

extension URL {
  static let onBoarding = Self.documentsDirectory.appending(component: "on-boarding.json")
}
