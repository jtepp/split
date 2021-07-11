//
//  ActivityWidgetEntryView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-05.
//

import SwiftUI
import WidgetKit

struct ActivityWidgetEntryView: View {
    var entry: ActivityProvider.Entry
    @Environment(\.widgetFamily) var family
    var body: some View {
        ActivityWidgetView(payments: entry.payments.filter({ p in
            return !p.isGM
        }), limit: family == .systemMedium ? 2 : 5)
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
//
//struct ActivityWidgetEntryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ActivityWidgetEntryView()
//    }
//}
