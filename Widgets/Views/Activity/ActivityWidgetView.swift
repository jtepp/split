//
//  ActivityWidgetView.swift
//  spllitWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-05.
//

import SwiftUI
import WidgetKit

struct ActivityWidgetView: View {
    var payments: [Payment]
    var limit: Int
    var body: some View {
        VStack {
            ForEach(payments.sorted(by: { a, b in
                return a.time > b.time
            }).prefix(limit)) { payment in
                if payment.isAn {
                    ActivityAnnouncementCell(payment: .constant(payment))
                } else if payment.isRequest {
//                    ActivityRequestCell(payment: .constant(payment))
                } else {
                    ActivityPaymentCell(payment: .constant(payment))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
    }
    }
}

struct ActivityWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityWidgetView(payments: [.placeholderr, .placeholder, .placeholdera, .placeholder, .placeholder, .placeholder, .placeholder, .placeholder], limit: 3)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
