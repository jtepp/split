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
    @State var members = [Member]()

    @Environment(\.widgetFamily) var family
    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SmallBalanceWidget(members: $members)
            case .systemMedium:
                MediumBalanceWidget(members: $members)
            case .systemLarge:
                LargeBalanceWidget(members: $members)
            default:
                SmallBalanceWidget(members: $members)
            }
        }
        .onAppear{
            Fetch().balanceWidgetMembers(members: $members, myId: entry.myId, houseId: entry.houseId)
        }
    }
}

struct BalanceWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceWidgetEntryView(entry: spllitEntry(date: Date(), myId: "placeholder", houseId: "placeholder"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
