//
//  EditRequestView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-12-19.
//

import SwiftUI

struct EditRequestView: View {
    @Binding var payment: Payment
    @Binding var mems: [Member]
    var body: some View {
        Text("Hello, World!")
    }
}

struct EditRequestView_Previews: PreviewProvider {
    static var previews: some View {
        EditRequestView(payment: .constant(.placeholder), mems: .constant([Member]()))
    }
}
