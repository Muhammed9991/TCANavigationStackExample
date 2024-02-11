import Foundation
import Dependencies
import DependenciesMacros

extension DependencyValues {
  var ageHelper: AgeHelper {
    get { self[AgeHelper.self] }
    set { self[AgeHelper.self] = newValue }
  }
}

@DependencyClient
struct AgeHelper {
    var isUser18orAbove: (_ dateOfBirth: String) -> Bool = { _ in false }
}

extension AgeHelper: DependencyKey {
    static var liveValue: Self {
        @Dependency(\.date.now) var now
        return Self { dateOfBirth in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            
            guard let birthDate = dateFormatter.date(from: dateOfBirth) else {
                // Being safe and assuming they are under 18. In reality some more logic will need to happen here
                return false
            }
            
            let ageComponents = Calendar.current.dateComponents([.year], from: birthDate, to: now)
            
            guard let age = ageComponents.year else {
                // Being safe and assuming they are under 18. In reality some more logic will need to happen here
                return false
            }
            
            return age >= 18
        }
    }
}
