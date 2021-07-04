//
//  BalanceWidget.swift
//  BalanceWidget
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> BalanceEntry {
        BalanceEntry(date: Date(), myId: "placeholder", houseId: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (BalanceEntry) -> ()) {
        let entry = BalanceEntry(date: Date(), myId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myId") ?? "", houseId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "houseId") ?? "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [BalanceEntry] = [BalanceEntry(date: Date(), myId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myId") ?? "", houseId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "houseId") ?? "")]

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()

        let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .second, value: 300, to: Date())!))
        
        completion(timeline)
    }
}


struct BalanceWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct BalanceWidget: Widget {
    let kind: String = "BalanceWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BalanceWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("spllit balances")
        .description("See a simplified view of who you owe and who owes you")
    }
}

struct BalanceWidget_Previews: PreviewProvider {
    static var previews: some View {
        BalanceWidgetEntryView(entry: BalanceEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
