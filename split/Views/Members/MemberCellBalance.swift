//
//  MemberCellBalance.swift
//  split
//
//  Created by Jacob Tepperman on 2021-09-25.
//

import SwiftUI

struct MemberCellBalance: View {
    @Binding var m: Member
    var body: some View {
        HStack {
            b64toimg(b64: m.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .background(Color.white)
                .shadow(radius: 4)
                .overlay(
                    Image(systemName: "crown.fill")
                        .offset(x: -3, y: -30)
                        .scaleEffect(x: 1.2)
                        .rotationEffect(.degrees(-30))
                        .foregroundColor(Color.white.opacity(m.admin ? 1 : 0))
                )
            VStack(alignment: .trailing) {
                Text(m.name)
                    .bold()
            }
            Spacer()
            VStack {
                Text(memberBalance(m: m))
                    .font(.footnote)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
            }
        }
        .foregroundColor(.primary)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    Color("Material")
                )
        )
        .frame(height: 40)
    }
}

func memberBalance(m: Member) -> String {
    var bal: Float = 0.0
    bal = m.owesMe.values.reduce(0, {a, b in
        a + b
    }) - m.iOwe.values.reduce(0, { a, b in
        a + b
    })
//    for name in m.iOwe {
//        if m.owesMe[name.key] ?? nil != nil {
//            bal += m.owesMe[name.key]! - name.value
//        }
//    }
    return "\(bal < 0 ? "-" : "")" + String(format: "$%.2f", abs(bal))
}


func memberBalanceFloat(m: Member) -> Float {
    var bal: Float = 0.0
    bal = m.owesMe.values.reduce(0, {a, b in
        a + b
    }) - m.iOwe.values.reduce(0, { a, b in
        a + b
    })
    return bal
}
