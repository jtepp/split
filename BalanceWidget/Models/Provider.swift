//
//  Provider.swift
//  BalanceWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import Foundation
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> BalanceEntry {
        BalanceEntry(date: Date(), myId: "placeholder", houseId: "placeholder")
    }

    func getSnapshot(in context: Context, completion: @escaping (BalanceEntry) -> ()) {
        let entry = BalanceEntry(date: Date(), myId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myId") ?? "", houseId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "houseId") ?? "")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BalanceEntry>) -> ()) {
        var entries: [BalanceEntry] = [BalanceEntry(date: Date(), myId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myId") ?? "", houseId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "houseId") ?? "")]

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()

        let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .second, value: 300, to: Date())!))
        
        completion(timeline)
    }
}
