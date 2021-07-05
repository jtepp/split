//
//  SmallBalanceWidget.swift
//  spllitWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import SwiftUI

struct SmallBalanceWidget: View {
    @Binding var members: [Member]
    var body: some View {
        Text("\(members.count)")
    }
}

struct SmallBalanceWidget_Previews: PreviewProvider {
    static var previews: some View {
        SmallBalanceWidget(members: .constant([Member]()))
    }
}
