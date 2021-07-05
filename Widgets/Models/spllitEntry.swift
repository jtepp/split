//
//  BalanceEntry.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import Foundation
import WidgetKit

struct spllitEntry: TimelineEntry {
    let date = Date()
    var myId: String = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myId") ?? ""
    var houseId: String = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "houseId") ?? ""
    var members: [codableMember]
}
