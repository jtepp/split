//
//  SmallBalanceWidget.swift
//  spllitWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import SwiftUI

struct BalanceWidgetView: View {
    var members: [codableMember]
    let rows: Int
    let cols: Int
    var body: some View {
        VStack {
            ForEach(members.sorted(by: { a, b in
                let myName = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myName") ?? "0"
                let aa = abs((a.iOwe[myName] ?? 0) - (a.owesMe[myName] ?? 0))
                let bb = abs((b.iOwe[myName] ?? 0) - (b.owesMe[myName] ?? 0))
                return aa > bb
            })){ member in
                Text(member.name)
                    .foregroundColor(.blue)
            }
            Circle()
                .fill(Color.blue)
        }
    }
}

struct SmallBalanceWidget_Previews: PreviewProvider {
    static var previews: some View {
        BalanceWidgetView(members: [codableMember](), rows: 2, cols: 2)
    }
}
