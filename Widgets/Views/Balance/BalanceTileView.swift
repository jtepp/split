//
//  BalanceTileView.swift
//  spllitWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-05.
//

import SwiftUI
import WidgetKit

struct BalanceTileView: View {
    var member: codableMember
    var body: some View {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("DarkMaterial"))
                    .overlay(
                        VStack {
                            b64toimg(b64: member.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color("Material"))
                                )
                            Text(member.name)
                        }
                    )
    }
}

struct BalanceTileView_Previews: PreviewProvider {
    static var previews: some View {
        BalanceWidgetView(members: [.placeholder,.placeholder,.placeholder2,.placeholder2], rows: 2, cols: 2)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
