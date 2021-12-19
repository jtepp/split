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
                b64toimg(b64: (mems.first(where: { m in
                    m.id == payment.by
                }) ?? .empty).image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 25, height: 25)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: 6)
                    .padding(.trailing, -5)
                Text(payment.from)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                Image(systemName: "arrow.right")
                HStack {
                    b64toimg(b64: (mems.first(where: { m in
                        m.name == payment.to
                    }) ?? .empty).image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(radius: 6)
                        .padding(.trailing, -5)
                    Text(payment.to)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
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
