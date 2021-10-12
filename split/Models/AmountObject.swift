//
//  AmountObject.swift
//  split
//
//  Created by Jacob Tepperman on 2021-10-09.
//

import SwiftUI

class AmountObject: ObservableObject {
    @Published var values = [Float]()
    @Published var bulkValues = [String: Float]()
    @Published var bulkPeople = [Member]()
    @Published var canCloseOverlay = false
    @Published var showOverlay = false
    @Published var showBulk = false
    var namespace: Namespace.ID
    init(_ namespace: Namespace.ID) {
        self.namespace = namespace
    }
    func total() -> Float {
        return self.values.reduce(0) { a, b in
            a+b
        }
    }
    func clearBulk() {
        self.bulkValues = [String: Float]()
        self.bulkPeople = [Member]()
    }
    
    func clear() {
        self.values = [Float]()
        self.bulkValues = [String: Float]()
        self.bulkPeople = [Member]()
        self.showBulk = false
        self.showOverlay = false
        self.canCloseOverlay = false
    }
    func placeholder() -> AmountObject {
        let x = AmountObject(Namespace().wrappedValue)
        x.values = [10,20,30]
        return x
    }
}
