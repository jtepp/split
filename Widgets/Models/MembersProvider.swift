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
        
        var entryMembers = [codableMember]()
        
        if let savedMembers = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.object(forKey: "members") as? Data {
            let decoder = JSONDecoder()
            if let loadedMembers = try? decoder.decode([codableMember].self, from: savedMembers){
                entryMembers = loadedMembers
            }
        }
        
        let entry = spllitEntry(myId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myId") ?? "", houseId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "houseId") ?? "", members: entryMembers)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<spllitEntry>) -> ()) {
        
        var entryMembers = [codableMember]()
        
        if let savedMembers = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.object(forKey: "members") as? Data {
            let decoder = JSONDecoder()
            if let loadedMembers = try? decoder.decode([codableMember].self, from: savedMembers){
                entryMembers = loadedMembers
            }
        }
        
        var entries: [spllitEntry] = [spllitEntry(myId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myId") ?? "", houseId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "houseId") ?? "", members: entryMembers)]

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()

        let timeline = Timeline(entries: entries, policy: .after(Calendar.current.date(byAdding: .second, value: 300, to: Date())!))
        
        completion(timeline)
    }
}
