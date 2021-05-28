//
//  ActivityAnnouncementCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-28.
//

import SwiftUI

struct ActivityAnnouncementCell: View {
    @Binding var payment: Payment
    @State var showMemo = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(payment.memo)
                Spacer()
            }
        }
        .foregroundColor(.white)
        .padding()
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
                TimeBar(unix: payment.time)
                    .padding(.horizontal)
            }
        )
    }
}

