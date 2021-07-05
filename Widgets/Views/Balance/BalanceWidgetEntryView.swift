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
                SmallBalanceWidget(members: Array(entry.members.prefix(4)))
            case .systemMedium:
                MediumBalanceWidget(members: Array(entry.members.prefix(6)))
            case .systemLarge:
                LargeBalanceWidget(members: Array(entry.members.prefix(9)))
            default:
                SmallBalanceWidget(members: Array(entry.members.prefix(4)))
            }
    
    }
}

//struct BalanceWidgetView_Previews: PreviewProvider {
//    static var previews: some View {
//        BalanceWidgetEntryView(entry: spllitEntry(date: Date(), myId: "placeholder", houseId: "placeholder"))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
