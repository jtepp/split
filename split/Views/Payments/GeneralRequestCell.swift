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
    @Binding var m: Member
    @State var showEach = false
    var hId: String
    var mems: [Member]
    var body: some View {
        HStack {
            HStack {
                b64toimg(b64: m.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 25, height: 25)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .shadow(radius: 6)
                    .overlay(
                        Image(systemName: "crown.fill")
                            .offset(x: -3, y: -20)
                            .scaleEffect(0.6)
                            .rotationEffect(.degrees(-30))
                            .foregroundColor(Color.white.opacity(m.admin ? 1 : 0))
                    )
                    .padding(.trailing, -5)
                Text(payment.to)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                //                if payment.reqfrom.count > 1 {
                //                    Image(systemName: "arrow.triangle.merge")
                //                        .rotationEffect(.degrees(-90))
                //                } else {
                Image(systemName: "arrow.left")
                //                }
                if minimal && payment.to != m.name {
                    Text(m.name)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                } else {
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
            }
            Spacer()
            HStack {
                if showEach {
                    moneyText(b: (minimal && payment.to != m.name) ? .constant(payment.amount / Float(payment.reqfrom.count)) : .constant($payment.wrappedValue.amount / Float($payment.wrappedValue.reqfrom.count)), post: showEach ? " each" : "")
                        .foregroundColor(.primary)
                        .padding(6)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(
                                    Color("whiteblack")
                                )
                        )
                } else {
                    moneyText(b: (minimal && payment.to != m.name) ? .constant(payment.amount / Float(payment.reqfrom.count)) : $payment.amount)
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
            .overlay(
                HStack {
                    if payment.includedSelf {
                        Image(systemName: "person.circle")
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


struct GeneralRequestCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityRequestCell(payment: .constant(.placeholderr), hId: "placeholder", mems: [Member(id: "a", home: "", name: "Devon", image: "", admin: true)])
        }
    }
}
