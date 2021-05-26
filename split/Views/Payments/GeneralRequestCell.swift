//
//  GeneralRequestCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct GeneralRequestCell: View {
    @Binding var payment: Payment
    var body: some View {
        HStack {
            HStack {
                Text(payment.to)
                    .font(.headline)
//                if payment.reqfrom.count > 1 {
//                    Image(systemName: "arrow.triangle.merge")
//                        .rotationEffect(.degrees(-90))
//                } else {
                    Image(systemName: "arrow.left")
//                }
                VStack(alignment: .leading) {
                    ForEach(payment.reqfrom, id: \.self) { member in
                        Text(member)
                            .font(.headline)
                    }
                }
            }
            Spacer()
            moneyText(b: $payment.amount)
                .foregroundColor(.white)
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            Color.black.opacity(0.5)
                        )
                )
        }
    }
}
