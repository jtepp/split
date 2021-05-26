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
//            b64toimg(b64: m.image)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 50)
//                .clipShape(Circle())
//                .shadow(radius: 4)
            Spacer()
            VStack(alignment: .trailing) {
                Text(m.name)
                    .foregroundColor(.black)
                    .bold()
                Text("$\(m.balance, specifier: "%.2f")")
                    .foregroundColor(.black)
            }
        }
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
