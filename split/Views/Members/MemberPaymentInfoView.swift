//
//  MemberPaymentInfoView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct MemberPaymentInfoView: View {
    @Binding var member: Member
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    moneyText(b: $member.balance)
                        .font(.headline)
                    Spacer()
                }
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .frame(height:2)
            }
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    Color.white.opacity(0.2)
                )
        )
        .padding()
    }
}
