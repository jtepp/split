//
//  ProfileView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct ProfileView: View {
    @Binding var m: Member
    @State var showSignOut = false
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
                MemberPaymentInfoView(member: $m)
                Spacer()
                Button(action: {
                    showSignOut = true
                }, label: {
                    HStack {
                        Spacer()
                        Text("Sign Out")
                            .foregroundColor(.red)
                        Spacer()
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                Color.white.opacity(0.2)
                            )
                    )
                    .padding()
                })
                .alert(isPresented: $showSignOut, content: {
                    Alert(title: Text("Sign Out"), message: Text("Please confirm you want to sign out of this account"), primaryButton: Alert.Button.destructive(Text("Confirm"), action: {
                        //signout
                    }), secondaryButton: Alert.Button.cancel())
                })
                Text("ID: \(m.id)")
                    .font(.caption)
                    .foregroundColor(Color("Secondary"))
            }
            .padding(.vertical, 40)
            .foregroundColor(.white)
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
}

