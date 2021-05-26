//
//  MembersView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct MembersView: View {
    @Binding var house: House
    @State var showDetails = false
    @State var tappedMember = Member.placeholder
    var body: some View {
            ScrollView {
                HeaderText(text: "Members")
                ForEach(house.members) { member in
                        MemberCell(m: .constant(member))
                            .onTapGesture {
                                tappedMember = member
                                showDetails = true
                            }
                }
            }
            .onAppear(){
                tappedMember = house.members.first ?? Member.placeholder
            }
            .sheet(isPresented: $showDetails, content: {
                MemberDetailsView(member: $tappedMember)
            })
    }
}

struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView(house: .constant(House.empty))
                    .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

