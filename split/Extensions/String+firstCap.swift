//
//  String+isNumeric.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import Foundation

extension String {
    func firstCap() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
