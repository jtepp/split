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
                        BalanceTileView(member: balWidSort(members: members)[Int(c + r * cols)])
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

func balWidSort(members: [codableMember]) -> [codableMember] {
    let myName = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myName") ?? "0"
    return members.sorted(by: { a, b in
        let aa = abs((a.iOwe[myName] ?? 0) - (a.owesMe[myName] ?? 0))
        let bb = abs((b.iOwe[myName] ?? 0) - (b.owesMe[myName] ?? 0))
        return aa > bb
    })
}
