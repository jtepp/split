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
                    imgButton(member: .constant(member), choice: $choice, multiple: multiple)
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
    @Binding var choice: [Member]
    var multiple: Bool
    var body: some View {
        HStack {
            b64toimg(b64: member.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.blue)
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                        )
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
