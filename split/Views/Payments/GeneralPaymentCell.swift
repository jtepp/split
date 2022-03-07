//
//  GeneralPaymentCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct GeneralPaymentCell: View {
    @Binding var payment: Payment
    var mems: [Member]
    var body: some View {
        HStack {
            HStack {
                SingleMemberPhotoView(member: mems.first(where: { m in
                    m.name == payment.from
                }) ?? .empty)
                Image(systemName: "arrow.right")
                HStack {
                    SingleMemberPhotoView(member: mems.first(where: { m in
                        m.name == payment.to
                    }) ?? .empty)
                    Spacer(minLength: 0)
                }
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.black.opacity(0.2))
                    
                )
                
            }
            Spacer()
            moneyText(b: $payment.amount)
                .foregroundColor(.primary)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            Color("whiteblack")
                        )
                )
                .overlay(
                    HStack {
                        if payment.special != "" {
                            Image(systemName: specialImgName(payment.special))
                                .resizable()
                                .foregroundColor(.white)
                        .frame(width: 16, height: 16)
                        }
                    }.offset(x: 13, y: -12)
                    , alignment: .topTrailing
                )
        }
    }
}

func moneyText(b: Binding<Float>, pre: String = "", post: String = "") -> Text {
    return Text("\(pre)\(b.wrappedValue < 0 ? "-" : "")$\(abs(b.wrappedValue), specifier: "%.2f")\(post)")
}

struct GeneralPaymentCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView {
                ForEach(Range(0...10)) { _ in
                    ActivityPaymentCell(payment: .constant(.placeholder), mems: [Member]())
                }
            }
        }
        
        
    }
}
