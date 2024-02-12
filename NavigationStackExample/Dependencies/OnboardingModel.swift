import Foundation
import Dependencies
import DependenciesMacros


final class DateOfBirthModel: Codable, Sendable, Equatable {
    static func == (lhs: DateOfBirthModel, rhs: DateOfBirthModel) -> Bool {
        lhs.dateOfBirth == rhs.dateOfBirth
    }
    
    let dateOfBirth: Date?
    init(dateOfBirth: Date?) {
        self.dateOfBirth = dateOfBirth
    }
}

final class NamingModel: Codable, Sendable, Equatable {
    static func == (lhs: NamingModel, rhs: NamingModel) -> Bool {
        lhs.firstName == rhs.firstName && lhs.familyName == rhs.familyName
    }
    
    let firstName: String?
    let familyName: String?
    
    init(firstName: String?, familyName: String?) {
        self.firstName = firstName
        self.familyName = familyName
    }
}

extension URL {
  static let namingModel = Self.documentsDirectory.appending(component: "naming-model.json")
  static let dobModel = Self.documentsDirectory.appending(component: "dob-model.json")
}
