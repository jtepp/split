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
                Image(systemName: "arrow.right")
                Text(payment.from)
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
