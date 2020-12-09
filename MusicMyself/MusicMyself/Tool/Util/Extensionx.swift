//
//  Extensionx.swift
//  MusicMyself
//
//  Created by XYU on 09/12/2020.
//

import Foundation

extension Array where Element: Equatable {
    func distinct() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
