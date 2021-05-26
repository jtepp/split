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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    Color.white.opacity(0.5)
                )
        )
    }
}

struct ActivityPaymentCell_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityPaymentCell(payment: .constant(.placeholder))
        }
            
    }
}
