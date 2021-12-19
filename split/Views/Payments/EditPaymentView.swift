//
//  EditPaymentView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-12-19.
//

import SwiftUI

struct EditPaymentView: View {
    @Binding var payment: Payment
    @Binding var showEdit: Bool
    var body: some View {
        ScrollView {
            HStack {
                HeaderText(text: "Edit  \(ptToString(payment.type))", space: false, clear: .constant(false))
                Spacer()
                Button {
                    //save and close
                } label: {
                    Text("Save")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                        .fill(Color.blue)
                        )
                }
            }
        }
    }
}

struct EditPaymentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            EditPaymentView(payment: .constant(.placeholder), showEdit: .constant(true))
        }
    }
}
