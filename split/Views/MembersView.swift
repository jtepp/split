//
//  MembersView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct MembersView: View {
    @Binding var house: House
    var body: some View {
        ForEach(house.members) { member in
            MemberCell(m: .constant(member))
        }
    }
}

struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView(house: .constant(House.empty))
    }
}

func b64toimg(b64: String) -> Image {
    let data = Data(base64Encoded: b64)
    var img = Image(systemName: "gear")
    if let data = data {
        img = Image(uiImage: UIImage(data: data)!)
    }
    return img
}

func imgtob64(img: UIImage) -> String {
    let data = img.jpegData(compressionQuality: 1)
    return data!.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
}
