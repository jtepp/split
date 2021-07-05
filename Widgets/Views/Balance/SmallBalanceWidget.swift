//
//  SmallBalanceWidget.swift
//  spllitWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import SwiftUI

struct SmallBalanceWidget: View {
    var members: [codableMember]
    var body: some View {
        VStack {
            ForEach(members){ member in
                Text(member.name)
                    .foregroundColor(.red )
            }
            Circle()
                .fill(Color.red)
        }
    }
}

struct SmallBalanceWidget_Previews: PreviewProvider {
    static var previews: some View {
        SmallBalanceWidget(members: [codableMember]())
    }
}
