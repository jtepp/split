//
//  GeneralRequestCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct GeneralRequestCell: View {
    @Binding var payment: Payment
    var minimal: Bool = false
//    @Binding var m: Member
    @State var showEach = false
    var hId: String
    var mems: [Member]
    var body: some View {
        HStack {
            HStack {
                SingleMemberPhotoView(member: mems.first(where: { m in
                    m.name == payment.to
                }) ?? .empty)

                Image(systemName: "arrow.left")
                //                }

                    //                    VStack(alignment: .leading) {
                    //                        ForEach(payment.reqfrom, id: \.self) { member in
                    //                            Text(member)
                    //                                .font(.headline)
                    //                                .lineLimit(1)
                    //                                .minimumScaleFactor(0.1)
                    //                        }
                    //                    }
                    ReqFromView(reqfrom: $payment.reqfrom, id: hId, mems: mems)
                        .padding(4)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.black.opacity(0.2))
                        )
                
            }
            Spacer()
            HStack {
                if showEach {
                    moneyText(b: (minimal) ? .constant(payment.amount / Float(payment.reqfrom.count)) : .constant($payment.wrappedValue.amount / Float($payment.wrappedValue.reqfrom.count)), post: showEach ? " each" : "")
                        .foregroundColor(.primary)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    Color("whiteblack")
                                )
                        )
                } else {
                    moneyText(b: (minimal) ? .constant(payment.amount / Float(payment.reqfrom.count)) : $payment.amount)
                        .foregroundColor(.primary)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    Color("whiteblack")
                                )
                        )
                }
            }
            .onTapGesture {
                if !minimal && payment.reqfrom.count > 1 {
                    showEach.toggle()
                }
            }
            
        }
        .overlay(
            GeneralPaymentSymbol(payment: payment)
            , alignment: .topLeading
        )
    }
}


struct GeneralRequestCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityRequestCell(payment: .constant(.placeholderr), hId: "placeholder", mems: [Member(id: "a", home: "", name: "Devon", image: "", admin: true)])
        }
    }
}


func paymentPlusSelfTotal(_ payment: Payment) -> String {
    let mc: Float = Float(payment.reqfrom.count)
    let total: Float = payment.amount * (mc + 1) / mc
    return String(format: "$%.2f", arguments: [total])
}
