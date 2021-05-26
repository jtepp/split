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
                .frame(width: 50, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 4)
            Spacer()
            VStack(alignment: .trailing) {
                Text(m.name)
                    .bold()
                Text("\(m.balance < 0 ? "-" : "")$\(abs(m.balance), specifier: "%.2f")")
            }
            Image(systemName: "chevron.right")
        }
        .foregroundColor(.black)
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    Color.white.opacity(0.4)
                )
        )
        .padding()
    }
}


func b64toimg(b64: String) -> Image {
    let data = Data(base64Encoded: b64)
    var img = Image(systemName: "gear")
    guard let d = data else {
        print(data ?? "uh oh")
        return img
    }
    img = Image(uiImage: (UIImage(data: d) ?? UIImage(systemName: "person.crop.circle"))!)
    return img
}

func imgtob64(img: UIImage) -> String {
    let data = img.jpegData(compressionQuality: 1)
    return data!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
}
