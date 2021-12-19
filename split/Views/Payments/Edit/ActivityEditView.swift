//
//  EditPaymentView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-12-19.
//

import SwiftUI

struct ActivityEditView: View {
    @Binding var payment: Payment
    @Binding var mems: [Member]
    @Binding var showEdit: Bool
    var body: some View {
        ScrollView {
            HStack {
                HeaderText(text: "Edit  \(ptToString(payment.type).firstCap())", space: false, clear: .constant(false))
                Spacer()
                Button {
                    //save and close
                } label: {
                    Text("Save")
                        .font(.headline)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.blue)
                        )
                }
            }
            HStack {
                Text("By:")
                    .font(.headline)
                    .bold()
                singleMemberPhotoView(member: mems.first(where: { m in
                    m.id == payment.by
                }) ?? .empty)
            }
            switch (payment.type) {
            case .payment: Text("PAY")
            case .request: Text("REQ")
            default: Text("EMPTY")
            }
        }
        .foregroundColor(.white)
    }
}

struct ActivityEditView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityEditView(payment: .constant(.placeholder), showEdit: .constant(true), mems: .constant([Member]()))
        }
    }
}
