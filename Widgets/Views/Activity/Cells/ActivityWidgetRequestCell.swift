//
//  ActivityRequestCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI
import WidgetKit

struct ActivityWidgetRequestCell: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var payment: Payment
    @State var showMemo = false
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text(payment.to)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)

                    Image(systemName: "arrow.left")

                        VStack(alignment: .leading) {
                            ForEach(payment.reqfrom, id: \.self) { member in
                                Text(member)
                                    .font(.headline)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                            }
                        }
                }
                Spacer()
                HStack {
                        moneyTextWidget(b: $payment.amount)
                            .foregroundColor(.primary)
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        Color("whiteblack")
                                    )
                        )
                }
            }
            .padding(.vertical, 6)
            
            WidgetTimeBar(unix: payment.time, white: colorScheme == .dark)
        }
        .padding(.horizontal)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    Color("Material")
                )
    )
    }
}

struct ActivityWidgetRequestCell_Preview: PreviewProvider {
    static var previews: some View {
        ActivityWidgetView(payments: [.placeholderr, .placeholderr, .placeholder, .placeholder, .placeholdera], limit: 5)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
