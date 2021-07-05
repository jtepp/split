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
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color("Material"))
                                )
                                .padding(.top, 6)
                            Text(member.name)
                                .font(Font.caption2.weight(.bold))
                                .foregroundColor(Color("Material"))
                            Text(balWidCalc(member:member))
                                .font(Font.caption2.weight(.bold))
                                .foregroundColor(Color("Material"))
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

func balWidCalc(member: codableMember) -> String {
    let myName = UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myName") ?? "0"
    let num = (member.iOwe[myName] ?? 0) - (member.owesMe[myName] ?? 0)
    return String(format: "$%.2f", num)
}
