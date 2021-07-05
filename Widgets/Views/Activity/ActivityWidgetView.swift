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
            }).prefix(
            
                easeLimitWithReqs(payments: payments, limit: limit)
            
            
            
            )) { payment in
                if payment.isAn {
                    ActivityWidgetAnnouncementCell(payment: .constant(payment))
                } else if payment.isRequest {
                    ActivityWidgetRequestCell(payment: .constant(payment))
                } else {
                    ActivityWidgetPaymentCell(payment: .constant(payment))
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
    }
//        .padding(.bottom, -6)
    }
}

struct ActivityWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityWidgetView(payments: [.placeholderr, .placeholder, .placeholdera, .placeholder, .placeholder, .placeholder, .placeholder, .placeholder], limit: 2)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

func easeLimitWithReqs(payments: [Payment], limit: Int) -> Int {
    let numReqs = payments.sorted(by: { a, b in
        return a.time > b.time
    }).prefix(limit).map({ p -> Double in
        if p.reqfrom.count == 2 {
            return 0.25
        } else if p.reqfrom.count > 2 {
            return 0.67//Double(p.reqfrom.count)/2
        } else {
            return 0
        }
    }).reduce(0){$0+$1}
    
    return Int(Double(limit) - numReqs + 1)
}
