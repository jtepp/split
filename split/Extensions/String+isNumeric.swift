//
//  String+isNumeric.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import Foundation

extension String {
    var isNumeric: Bool {
        guard self.characters.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
        return Set(self.characters).isSubset(of: nums)
    }
}
