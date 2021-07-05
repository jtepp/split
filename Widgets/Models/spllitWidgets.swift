//
//  BalanceWidget.swift
//  BalanceWidget
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import WidgetKit
import SwiftUI


@main
struct BalanceWidget: Widget {
    let kind: String = "BalanceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BalanceWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("spllit Balances")
        .description("See a simplified view of who you owe and who owes you")
    }
}

struct BalanceWidget_Previews: PreviewProvider {
    static var previews: some View {
        BalanceWidgetEntryView(entry: spllitEntry(date: Date(), myId: "placeholder", houseId: "placeholder"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
