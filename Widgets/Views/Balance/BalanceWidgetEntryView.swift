//
//  BalanceWidgetView.swift
//  BalanceWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import SwiftUI
import WidgetKit

struct BalanceWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family
    
    
    var body: some View {
            switch family {
            case .systemSmall:
                BalanceWidgetView(members: Array(entry.members), rows: 2, cols: 2)
            case .systemMedium:
                BalanceWidgetView(members: Array(entry.members), rows: 2, cols: 4)
            case .systemLarge:
                BalanceWidgetView(members: Array(entry.members), rows: 4, cols: 4)
            default:
                BalanceWidgetView(members: Array(entry.members), rows: 2, cols: 2)
            }
    
    }
}

//struct BalanceWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        BalanceWidgetEntryView(entry: spllitEntry(date: Date(), myId: "placeholder", houseId: "placeholder"))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
