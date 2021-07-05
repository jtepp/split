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
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            ForEach(payments.sorted(by: { a, b in
                return a.time > b.time
            }).prefix(limit)) { payment in
                if payment.isAn {
                    WidgetActivityAnnouncementCell(payment: .constant(payment))
                } else if payment.isRequest {
//                    WidgetActivityRequestCell(payment: .constant(payment))
                } else {
                    ActivityWidgetPaymentCell(payment: .constant(payment))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
    }
        .padding(.bottom, -10)
    }
}

struct ActivityWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityWidgetView(payments: [.placeholderr, .placeholder, .placeholdera, .placeholder, .placeholder, .placeholder, .placeholder, .placeholder], limit: 2)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
