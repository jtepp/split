//
//  ActivityView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct ActivityView: View {
    @Binding var house: House
    var body: some View {
        ScrollView {
            HeaderText(text: "Activity")
            ForEach(house.payments.sorted(by: { a, b in
                return a.time > b.time
            })) { payment in
                ActivityPaymentCell(payment: .constant(payment))
                    .padding(.bottom, -20)
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}
