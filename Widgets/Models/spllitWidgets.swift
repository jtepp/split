//
//  BalanceWidget.swift
//  BalanceWidget
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import WidgetKit
import SwiftUI
import Firebase


@main
struct spllitWidgets: WidgetBundle {
    init() {
        FirebaseApp.configure()
      }
    @WidgetBundleBuilder
    var body: some Widget {
        BalanceWidget()
    }
}

struct BalanceWidget: Widget {
    let kind: String = "BalanceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MembersProvider()) { entry in
            BalanceWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("spllit Balances")
        .description("See a simplified view of who you owe and who owes you")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct ActivityWidget: Widget {
    let kind: String = "ActivityWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ActivityProvider()) { entry in
            ActivityWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("spllit Activity")
        .description("See your group's recent activity")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

//struct BalanceWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        BalanceWidgetEntryView(entry: MembersEntry(date: Date(), myId: "placeholder", houseId: "placeholder"))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
