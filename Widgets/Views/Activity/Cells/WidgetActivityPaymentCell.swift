//
//  ActivityPaymentCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct WidgetActivityPaymentCell: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var payment: Payment
    @State var showMemo = false
    var body: some View {
        GeneralPaymentCell(payment: $payment)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        Color("Material")
                    )
            )
            
            .overlay(
                TimeBar(unix: payment.time, white: colorScheme == .dark)
                    .padding(.horizontal, 4)
                    .offset(y: 16)
            )
    }
}
//
//struct ActivityPaymentCell_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.black.edgesIgnoringSafeArea(.all)
//            ScrollView {
//                ForEach(Range(0...10)) { _ in
//                    ActivityPaymentCell(payment: .constant(.placeholder))
//                }
//            }
//        }
//
//    }
//}
