//
//  ActivityPaymentCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct ActivityPaymentCell: View {
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
            moneyText(b: $payment.amount)
        }
        .foregroundColor(.black)
    }
}
