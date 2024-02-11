import Foundation

extension String {
    var isWhitespaceOrEmpty: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
