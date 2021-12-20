//
//  EditRequestView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-12-19.
//

import SwiftUI

struct EditRequestView: View {
    @Binding var house: House
    var member: Member
    var payment: Payment
    @Binding var mems: [Member]
    @Binding var amountText: String
    var body: some View {
        Text("Hello, World!")
    }
}

struct EditRequestView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityEditView(house: .constant(.placeholder), member: .empty, payment: .placeholderr, mems: .constant([Member]()), showEdit: .constant(true))
        }
    }
}
