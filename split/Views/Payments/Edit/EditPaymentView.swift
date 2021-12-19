//
//  EditPaymentView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-12-19.
//

import SwiftUI

struct EditPaymentView: View {
    var payment: Payment
    @Binding var mems: [Member]
    var body: some View {
        Text("Hello, World!")
    }
}

struct EditPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        EditPaymentView(payment: .placeholder, mems: .constant([Member]()))
    }
}
