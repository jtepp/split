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
            ForEach(members){ member in
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
