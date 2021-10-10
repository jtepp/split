//
//  AmountObject.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-09.
//

import Foundation

class AmountObject: ObservableObject {
    var show = false
    var values = [Float]()
    func total() -> Float {
        return self.values.reduce(0) { a, b in
            a+b
        }
    }
    func clear() {
        self.values = [Float]()
    }
}
