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
                    Image(systemName: m.admin ? "crown.fill" : "")
                        .offset(x: -3, y: -30)
                        .scaleEffect(x: 1.2)
                        .rotationEffect(.degrees(-30))
                        .foregroundColor(.white)
                )
            Spacer()
            VStack(alignment: .trailing) {
                Text(m.name)
                    .bold()
                moneyText(b: $m.balance)
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
    img = Image(uiImage: (UIImage(data: d) ?? UIImage(systemName: "person.crop.square"))!)
    return img
}

func imgtob64(img: UIImage) -> String {
    let data = img.jpegData(compressionQuality: 1)
    return data!.base64EncodedString()
}

func moneyText(b: Binding<Float>, pre: String = "") -> Text {
    return Text("\(pre)\(b.wrappedValue < 0 ? "-" : "")$\(abs(b.wrappedValue), specifier: "%.2f")")
}
