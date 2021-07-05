//
//  Provider.swift
//  BalanceWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import Foundation
import WidgetKit

struct MembersProvider: TimelineProvider {
    func placeholder(in context: Context) -> spllitEntry {
        spllitEntry(myId: "placeholder", houseId: "placeholder", members: [.placeholder, .placeholder2])
    }

    func getSnapshot(in context: Context, completion: @escaping (spllitEntry) -> ()) {
        let entry = spllitEntry(myId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myId") ?? "", houseId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "houseId") ?? "", members: [.placeholder])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<spllitEntry>) -> ()) {
        var entries: [spllitEntry] = [spllitEntry(myId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myId") ?? "", houseId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "houseId") ?? "", members: [.placeholder])]

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()

        let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .second, value: 300, to: Date())!))
        
        completion(timeline)
    }
}
