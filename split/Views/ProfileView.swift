//
//  ProfileView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct ProfileView: View {
    @Binding var m: Member
    var body: some View {
        ScrollView {
            HeaderText(text: "Profile")
            VStack {
                b64toimg(b64: m.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(radius: 4)
                Text(m.name)
                    .font(.largeTitle)
                    .bold()
                if m.admin {
                    Text("House admin")
                }
                Spacer()
                Text("ID: \(m.id)")
                    .font(.caption)
                    .foregroundColor(Color("Secondary"))
                Spacer()
                MemberPaymentInfoView(member: $m)
            }
            .padding(.vertical, 40)
        }
    }
}

