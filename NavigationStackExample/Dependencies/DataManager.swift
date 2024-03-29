import Dependencies
import DependenciesMacros
import Foundation

extension DependencyValues {
    var dataManager: DataManager {
        get { self[DataManager.self] }
        set { self[DataManager.self] = newValue }
    }
}

struct DataManager: Sendable {
    var isDataAvailable: @Sendable (_ from: URL) -> Bool
    var load: @Sendable (_ from: URL) throws -> Data
    var save: @Sendable (Data, _ to: URL) async throws -> Void
    var delete: @Sendable (_ to: URL) async throws -> Void
}

extension DataManager: DependencyKey {
    static let liveValue = Self(
        isDataAvailable: { url in
            do {
                _ = try Data(contentsOf: url)
                return true
            } catch {
                return false
            }
        },
        load: { url in try Data(contentsOf: url) },
        save: { data, url in try data.write(to: url) }, 
        delete: { url in try FileManager.default.removeItem(at: url) }
    )
    
}

extension DataManager {
    static func mock(initialData: Data? = nil) -> Self {
        let data = LockIsolated(initialData)
        return Self(
            isDataAvailable: { _ in
                return true
            }, load: { _ in
                guard let data = data.value
                else {
                    struct FileNotFound: Error {}
                    throw FileNotFound()
                }
                return data
            },
            save: { newData, _ in data.setValue(newData) }, 
            delete: { _ in  }
        )
    }
    
    static let failToWrite = Self(
        isDataAvailable: { _ in true },
        load: { _ in Data() },
        save: { _, _ in
            struct SaveError: Error {}
            throw SaveError()
        }, 
        delete: { _ in  }
    )
    
    static let failToLoad = Self(
        isDataAvailable: { _ in false },
        load: { _ in
            struct LoadError: Error {}
            throw LoadError()
        },
        save: { _, _ in }, 
        delete: { _ in  }
    )
    
    static let failToDelete = Self(
        isDataAvailable: { _ in false },
        load: { _ in Data() },
        save: { _, _ in },
        delete: { _ in
            struct DeleteError: Error {}
            throw DeleteError()
        }
    )
}
