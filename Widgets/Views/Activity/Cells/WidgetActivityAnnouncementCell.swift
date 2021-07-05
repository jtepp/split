//
//  ActivityAnnouncementCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-28.
//

import SwiftUI

struct WidgetActivityAnnouncementCell: View {
    @Binding var payment: Payment
    @State var showMemo = false
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
                WidgetTimeBar(unix: payment.time, white: true)
                    .padding(.horizontal,4)
            }
        )
    }
}

