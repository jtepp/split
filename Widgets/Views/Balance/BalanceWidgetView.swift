//
//  SmallBalanceWidget.swift
//  spllitWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import SwiftUI
import WidgetKit

struct BalanceWidgetView: View {
    var members: [codableMember]
    let rows: Int
    let cols: Int
    var body: some View {
        VStack {
            ForEach(0..<rows){ r in
                HStack {
                    ForEach(0..<cols){ c in
                        if members.count > Int(c + r * cols) {
                            BalanceTileView(member: balWidSort(members: members, index: Int(c + r * cols)))
                        } else {
                            Spacer()
                        }
                    }
                }
            }
        }
        .padding(8)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct SmallBalanceWidget_Previews: PreviewProvider {
    static var previews: some View {
        BalanceWidgetView(members: [.placeholder,.placeholder,.placeholder,.placeholder2], rows: 2, cols: 2)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

func balWidSort(members: [codableMember], index: Int) -> codableMember {
    let myName = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myName") ?? "0"
    let sorted = members.sorted(by: { a, b in
        let aa = abs((a.iOwe[myName] ?? 0) - (a.owesMe[myName] ?? 0))
        let bb = abs((b.iOwe[myName] ?? 0) - (b.owesMe[myName] ?? 0))
        return aa > bb
    })
    if sorted.count > index {
        return sorted[index]
    } else {
        print("WAS OUT OF INDEX \(index) \(sorted.count)")
        
        if let savedMembers = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.object(forKey: "members") as? Data {
            let decoder = JSONDecoder()
            if let loadedMembers = try? decoder.decode([codableMember].self, from: savedMembers){
                print(loadedMembers)
            }
        }
        
        return .empty
    }
}
