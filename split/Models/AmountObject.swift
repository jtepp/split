//
//  AmountObject.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-09.
//

import Foundation

class AmountObject: ObservableObject {
    @Published var values = [Float]()
    func total() -> Float {
        return self.values.reduce(0) { a, b in
            a+b
        }
    }
    func clear() {
        self.values = [Float]()
    }
    func placeholder() -> AmountObject {
        let x = AmountObject()
        x.values = [10,20,30]
        return x
    }
}
