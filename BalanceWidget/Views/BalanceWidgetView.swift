//
//  BalanceWidgetView.swift
//  BalanceWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-04.
//

import SwiftUI
import WidgetKit

struct BalanceWidgetView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct BalanceWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceWidgetView(entry: BalanceEntry(date: Date(), myId: "placeholder", houseId: "placeholder"))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
