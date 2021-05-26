//
//  MemberDetailsView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct MemberDetailsView: View {
    @Binding var member: Member
    var body: some View {
        ZStack {
            MenuButton(member: $member) //only if current profile is admin

            VStack {
                b64toimg(b64: member.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(radius: 4)
                Text(member.name)
                    .font(.largeTitle)
                    .bold()
                if member.admin {
                    Text("House admin")
                }
                Spacer()
                MemberPaymentInfoView(member: $member)
            }
            .padding(.vertical, 40)
        }
        .foregroundColor(.white)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct MemberDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true), content: {
                MemberDetailsView(member: .constant(Member.placeholder))
                    .preferredColorScheme(.dark)
            })
        
    }
}

struct MenuButton: View {
    @Binding var member: Member
    //attach to house
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Menu(content: {
                    Button("Remove from house", action: {})
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(
                                    Color.white.opacity(0.2)
                                )
                        )
                        .padding(.vertical)
                        .padding(.horizontal, 10)
                })
            }
            Spacer()
        }
    }
}
