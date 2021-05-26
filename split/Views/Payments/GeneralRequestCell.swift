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
    var body: some View {
        HStack {
            HStack {
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
                    VStack(alignment: .leading) {
                        ForEach(payment.reqfrom, id: \.self) { member in
                            Text(member)
                                .font(.headline)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                        }
                    }
                }
            }
            Spacer()
            moneyText(b: (minimal && payment.to != m.name) ? .constant(payment.amount / Float(payment.reqfrom.count)) : $payment.amount)
                .foregroundColor(.black)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
//                            Color.black.opacity(0.5)
                            Color.white
                        )
                )
        }
    }
}
