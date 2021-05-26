//
//  GeneralPaymentCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct GeneralPaymentCell: View {
    @Binding var payment: Payment
    var body: some View {
        HStack {
            HStack {
                Text(payment.from)
                    .font(.headline)
                Image(systemName: "arrow.right")
                Text(payment.to)
                    .font(.headline)
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
