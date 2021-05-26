//
//  MemberPicker.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct MemberPicker: View {
    @Binding var house: House
    @Binding var choice: [Member]
    var multiple: Bool = false
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView {
                HeaderText(text: "Choose \(multiple ? "members" : "a member")")
                ForEach (house.members) { member in
                    HStack {
                        b64toimg(b64: member.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .shadow(radius: 4)
                            .overlay(
//                                Image(systemName: m.admin ? "crown.fill" : "")
//                                    .offset(x: -3, y: -30)
//                                    .scaleEffect(x: 1.2)
//                                    .rotationEffect(.degrees(-30))
//                                    .foregroundColor(.white)
                                EmptyView()
                            )
                        Spacer()
                        VStack(alignment: .trailing) {
                            Text(member.name)
                                .bold()
                        }
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
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
            }
        }
    }
}

struct MemberPicker_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            PaymentView(house: .constant(.placeholder))
        }
    }
}

struct imgButton: View {
    @Binding var member: Member
    @State var selected: Bool = false
    var body: some View {
        b64toimg(b64: member.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 40, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 4)
    }
}
