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
                //                moneyText(b: .constant(0.0))//$m.balance)
                if m.showStatus {
                    if !m.online {
                        Text("Last seen: \(unixtotime(unix: m.lastSeen)) \(unixtodate(unix: m.lastSeen))")
                    }
//                    HStack {
//                        if m.online {
//                            Label {
//                                Text("Online")
//                            } icon: {
//                                Image(systemName: "circlebadge.fill")
//                                    .foregroundColor(.green)
//                                    .shadow(color: .green.opacity(0.5), radius: 2, x: 0, y: 0)
//                            }
//                        } else {
//                            Label {
//                                Text("Last seen: \(unixtotime(unix: m.lastSeen))\n\(unixtodate(unix: m.lastSeen))")
//                            } icon: {
//                                Image(systemName: "circlebadge")
//                            }
//                        }
//                    }
//                    .font(.caption)
                }
            }
            //          Image(systemName: "chevron.right")
        }
        .foregroundColor(.black)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    Color.white.opacity(0.5)
                )
        )
    }
}


func b64toimg(b64: String) -> Image {
    let data = Data(base64Encoded: b64)
    var img = Image(systemName: "gear")
    guard let d = data else {
        print(data ?? "uh oh")
        return img
    }
    img = Image(uiImage: (UIImage(data: d) ?? UIImage(named: "Placeholder"))!)
    return img
}

func imgtob64(img: UIImage) -> String {
    let data = img.jpegData(compressionQuality: 1)
    return data!.base64EncodedString()
}

func moneyText(b: Binding<Float>, pre: String = "", post: String = "") -> Text {
    return Text("\(pre)\(b.wrappedValue < 0 ? "-" : "")$\(abs(b.wrappedValue), specifier: "%.2f")\(post)")
}
