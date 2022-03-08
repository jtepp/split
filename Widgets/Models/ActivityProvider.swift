//
//  Provider.swift
//  BalanceWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import Foundation
import WidgetKit

struct ActivityProvider: TimelineProvider {
    func placeholder(in context: Context) -> spllitEntry {
        spllitEntry(myId: "placeholder", houseId: "placeholder", members: Array(repeating: .empty, count: 9), payments: Array(repeating: .empty, count: 9))
    }

    func getSnapshot(in context: Context, completion: @escaping (spllitEntry) -> ()) {
        let myId = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myId") ?? "0"
        let houseId = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "houseId") ?? "actsnap"
        
//        var entryMembers = [codableMember]()
        
//        if let savedMembers = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.object(forKey: "members") as? Data {
//            let decoder = JSONDecoder()
//            if let loadedMembers = try? decoder.decode([codableMember].self, from: savedMembers){
//                entryMembers = loadedMembers
//            }
//        }
        
        Fetch.activityWidgetPayments(houseId: houseId) { loadedPayments in
            print("Lp \(loadedPayments.count)")
            let entry = spllitEntry(myId: myId, houseId: houseId, members: [.empty], payments: loadedPayments)
            completion(entry)
        }
        
        
        
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<spllitEntry>) -> ()) {
        
        let myId = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myId") ?? "0"
        let houseId = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "houseId") ?? "acttime"


        Fetch.activityWidgetPayments(houseId: houseId) { loadedPayments in
            print("Lp \(loadedPayments.count)")
            let entry = spllitEntry(myId: myId, houseId: houseId, members: [.empty], payments: loadedPayments)
            let curD = Date()
            let timeline = Timeline(entries: [entry], policy: .after(Calendar.current.date(byAdding: .second, value: 10, to: curD)!))
            
            completion(timeline)
            
        }
        
        
//        if let savedMembers = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.object(forKey: "members") as? Data {
//            let decoder = JSONDecoder()
//            if let loadedMembers = try? decoder.decode([codableMember].self, from: savedMembers){
//                let entry = spllitEntry(myId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myId") ?? "", houseId: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "houseId") ?? "", members: loadedMembers)
//
//                // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        //        let currentDate = Date()
//
//
//            }
//        }
        
    }
}
