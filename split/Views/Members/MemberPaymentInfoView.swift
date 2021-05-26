//
//  MemberPaymentInfoView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct MemberPaymentInfoView: View {
    @Binding var member: Member
    @Binding var payments: [Payment]
    var body: some View {
            VStack {
                HStack {
                    moneyText(b: $member.balance, pre: "Balance: ")
                        .font(.headline)
                    Spacer()
                }
                Rectangle()
                    .fill(Color.black.opacity(0.5))
                    .frame(height:2)
                
                ScrollView {
                    ForEach(payments.filter{ p in
                        return (p.to == member.name) || (p.from == member.name)
                    }.sorted(by: { (a, b) -> Bool in
                        return a.time > b.time
                    })){ payment in
                        GeneralPaymentCell(payment: .constant(payment))
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                    }
                
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                Color.black.opacity(0.5)
                            )
                )
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
