// MARK: - String Extension

extension String {
    var firstCharactor: String? {
        guard !self.isEmpty else { return nil }
        return String(self.prefix(1))
    }
}