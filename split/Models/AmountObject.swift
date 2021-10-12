//
//  AmountObject.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-09.
//

import SwiftUI

class AmountObject: ObservableObject {
    @Published var values = [Float]()
    @Published var showOverlay = false
    var namespace: Namespace
    init(_ namespace: Namespace) {
        self.namespace = namespace
    }
    func total() -> Float {
        return self.values.reduce(0) { a, b in
            a+b
        }
    }
    func clear() {
        self.values = [Float]()
    }
    func placeholder() -> AmountObject {
        let x = AmountObject(Namespace())
        x.values = [10,20,30]
        return x
    }
}
