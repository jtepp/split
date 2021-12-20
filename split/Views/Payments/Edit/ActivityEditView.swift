//
//  EditPaymentView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-12-19.
//

import SwiftUI

struct ActivityEditView: View {
    @Binding var house: House
    var member: Member
    var payment: Payment
    @Binding var mems: [Member]
    @Binding var showEdit: Bool
    @State var amountText = ""
    @State var editType: EditPickerType = .from
    @State var choiceFrom = [Member]()
    @State var choiceTo = [Member]()
    var body: some View {
        VStack {
            ScrollView {
                HStack {
                    HeaderText(text: "Edit \(ptToString(payment.type).firstCap())", space: false, clear: .constant(false))
                    Spacer()
                    Button {
                        //save and close
                        showEdit = false
                    } label: {
                        Text("Save")
                            .font(.headline)
                            .padding(10)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                            .fill(
                                                (Float(amountText) ?? nil != nil && !choiceFrom.isEmpty && !choiceTo.isEmpty) ?
                                                Color.blue :
                                                    Color.gray
                                            )
                            )
                    }
                    .disabled(!(Float(amountText) ?? nil != nil && !choiceFrom.isEmpty && !choiceTo.isEmpty))
                }
                HStack {
                    Text("By:")
                        .font(.headline)
                        .bold()
                    SingleMemberPhotoView(member: mems.first(where: { m in
                        m.id == payment.by
                    }) ?? .empty)
                }
                switch (payment.type) {
                case .payment: EditPaymentView(house: $house, member: member, payment: payment, mems: $mems, pickerFrom: $pickerFrom, choiceFrom: $choiceFrom, choiceTo: $choiceTo, amountText: $amountText)
                case .request: EditRequestView(house: $house, member: member, payment: payment, mems: $mems, amountText: $amountText)
                default: EmptyView()
                }
            }
            .foregroundColor(.white)
            Button {
                showEdit = false
            } label: {
                HStack {
                    Spacer()
                    Text("Cancel")
                        .font(.system(size: 20))
                        .bold()
                        .padding(.vertical, 0)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray)
                )
                .padding(.bottom, 80)
            }
        }
    }
}

struct ActivityEditView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityEditView(house: .constant(.placeholder), member: .empty, payment: .placeholder, mems: .constant([Member]()), showEdit: .constant(true))
        }
    }
}


enum EditPickerType {
    case .to
    case .from
}
