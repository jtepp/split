//
//  ActivityMessageCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-11.
//

import SwiftUI

struct ActivityMessageCell: View {
    @Binding var payment: Payment
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Text(payment.from)
                        .font(Font.body.weight(.heavy))
                        .padding(.trailing, -4)
                    Text(payment.memo)
                    Spacer()
                }
            }
            .foregroundColor(.white)
            .padding(.vertical, 2)
            .padding(.top, 6)
            .padding(.bottom, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        Color.gray.opacity(0.2)
                    )
            )
            .overlay(
                VStack {
                    Spacer()
                    TimeBar(unix: payment.time, white: true)
                        .padding(.horizontal,4)
                }
            )
    }
}

struct ActivityMessageCell_Previews: PreviewProvider {
    static var previews: some View {
        ActivityMessageCell(payment: .constant(.placeholderm))
    }
}
