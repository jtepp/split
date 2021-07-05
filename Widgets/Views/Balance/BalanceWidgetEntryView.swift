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
            SmallBalanceWidget(entry: entry)
        case .systemMedium:
            MediumBalanceWidget(entry: entry)
        case .systemLarge:
            LargeBalanceWidget(entry: entry)
        @unkown default:
            SmallBalanceWidget(entry: entry)
        }
    }
}

struct BalanceWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceWidgetEntryView(entry: spllitEntry(date: Date(), myId: "placeholder", houseId: "placeholder"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
