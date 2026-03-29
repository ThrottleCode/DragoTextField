//
//  TextField.swift
//  DragoTextField
//
//  Created by Amandeep Singh on 29/03/26.
//

// MARK: - String Extension

extension String {
    var firstCharactor: String? {
        guard !self.isEmpty else { return nil }
        return String(self.prefix(1))
    }
}
