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
            }
        }
    }
}

struct SmallBalanceWidget_Previews: PreviewProvider {
    static var previews: some View {
        SmallBalanceWidget(members: [codableMember]())
    }
}
