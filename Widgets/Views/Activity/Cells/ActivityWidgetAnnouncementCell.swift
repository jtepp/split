//
//  ActivityAnnouncementCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-28.
//

import SwiftUI

struct ActivityWidgetAnnouncementCell: View {
    @Binding var payment: Payment
    @State var showMemo = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(payment.from)
                    .font(Font.callout.weight(.heavy))
                    .padding(.trailing, -4)
                Text(payment.memo)
                    .font(Font.callout)
                Spacer()
            }
        }
        .foregroundColor(.white)
        .padding(.vertical, 2)
        .padding(.top, 4)
        .padding(.bottom, 8)
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

