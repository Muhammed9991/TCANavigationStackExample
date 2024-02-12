import Foundation
import Dependencies
import DependenciesMacros

extension DependencyValues {
  var onBoardingCache: OnboardingCache {
    get { self[OnboardingCache.self] }
    set { self[OnboardingCache.self] = newValue }
  }
}

@DependencyClient
struct OnboardingCache {
    var insert: (_ value: OnboardingCacheModel) -> Void
    var value: () -> OnboardingCacheModel?
    var removeValue: () -> Void
}

extension OnboardingCache: DependencyKey {
    static var liveValue: Self {
        let cache = NSCache<NSString, OnboardingCacheModel>()
        let key: NSString = "logged-in-user"
        
        return Self { value in
            cache.setObject(value, forKey: key)
        } value: {
            cache.object(forKey: key)
        } removeValue: {
            cache.removeObject(forKey: key)
        }
        
    }
}

final class OnboardingCacheModel {
    let fullName: String?
    let dateOfBirth: Date?
    
    init(fullName: String?, dateOfBirth: Date?) {
        self.fullName = fullName
        self.dateOfBirth = dateOfBirth
    }
}
