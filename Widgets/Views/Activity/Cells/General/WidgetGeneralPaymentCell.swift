//
//  GeneralPaymentCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct WidgetGeneralPaymentCell: View {
    @Binding var payment: Payment
    var body: some View {
        HStack {
            HStack {
                Text(payment.from)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                Image(systemName: "arrow.right")
                Text(payment.to)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            }
            Spacer()
            moneyTextWidget(b: $payment.amount)
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

func moneyTextWidget(b: Binding<Float>, pre: String = "", post: String = "") -> Text {
    return Text("\(pre)\(b.wrappedValue < 0 ? "-" : "")$\(abs(b.wrappedValue), specifier: "%.2f")\(post)")
}
