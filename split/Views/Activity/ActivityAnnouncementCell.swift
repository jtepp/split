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
            GeneralPaymentCell(payment: $payment)
            ScrollView {
                HStack {
                    Text("Payment")
                        .font(Font.caption.smallCaps().weight(Font.Weight.black))
                    Spacer()
                }
                HStack {
                    Text(payment.memo)
                    Spacer()
                }
            }
            .padding(.bottom, showMemo ? 20 : 0)
            .animation(.easeIn)
            .frame(maxHeight: showMemo ? 10000 : 0)
            .foregroundColor(showMemo ? .black : .clear)
        }
        .foregroundColor(.black)
        .padding()
        .padding(.bottom, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    Color.white.opacity(0.5)
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

