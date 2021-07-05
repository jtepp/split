//
//  BalanceWidgetView.swift
//  BalanceWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import SwiftUI
import WidgetKit

struct BalanceWidgetEntryView : View {
    var entry: MembersProvider.Entry

    @Environment(\.widgetFamily) var family
    
    
    var body: some View {
            switch family {
            case .systemSmall:
                SmallBalanceWidget(members: entry.members)
            case .systemMedium:
                MediumBalanceWidget(members: entry.members)
            case .systemLarge:
                LargeBalanceWidget(members: entry.members)
            default:
                SmallBalanceWidget(members: entry.members)
            }
    
    }
}

//struct BalanceWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        BalanceWidgetEntryView(entry: spllitEntry(date: Date(), myId: "placeholder", houseId: "placeholder"))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
