//
//  MemberCell.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct MemberCell: View {
    @Binding var m: Member
    var body: some View {
        HStack {
            b64toimg(b64: m.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 4)
                .overlay(
                    Image(systemName: "crown.fill")
                        .offset(x: -3, y: -30)
                        .scaleEffect(x: 1.2)
                        .rotationEffect(.degrees(-30))
                        .foregroundColor(Color.white.opacity(m.admin ? 1 : 0))
                )
            Spacer()
            VStack(alignment: .trailing) {
                Text(m.name)
                    .bold()
                if m.showStatus {
                    if !m.online && m.lastSeen != 0 {
                        if unixtodate(unix: Int(m.lastSeen)) == unixtodate(unix: Int(NSDate().timeIntervalSince1970)) {
                            Text("Last seen: \(unixtotime(unix: Int(m.lastSeen)))")
                                .font(.caption)
                        } else {
                            Text("Last seen: \(Date(timeIntervalSince1970: TimeInterval(truncating: m.lastSeen)).timeAgo()) ago")
                                .font(.caption)
                        }
                    }
                }
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
//        .overlay(
//            HStack(alignment: .center) {
//                if m.showStatus {
//                if m.online {
//                    Image(systemName: "circlebadge.fill")
//                        .foregroundColor(.green)
//                        .background(
//                            Image(systemName: "circlebadge.fill")
//                                .foregroundColor(.green)
//                                .blur(radius: 2)
////                                .scaleEffect(1.2)
//                        )
//                } else {
//                    Image(systemName: "circlebadge")
//                        .foregroundColor(.primary)
//                }
//                Spacer()
//                }
//            }
//            .font(.caption2)
//            .padding(.leading, 4)
//        )
    }
}



func b64touiimg(b64: String) -> UIImage? {
    let data = Data(base64Encoded: b64)
    var img = UIImage(systemName: "gear")
    guard let d = data else {
        print(data ?? "uh oh")
        return img
    }
    img = (UIImage(data: d) ?? UIImage(named: "Placeholder"))!
    return img
}



func moneyText(b: Binding<Float>, pre: String = "", post: String = "") -> Text {
    return Text("\(pre)\(b.wrappedValue < 0 ? "-" : "")$\(abs(b.wrappedValue), specifier: "%.2f")\(post)")
}
