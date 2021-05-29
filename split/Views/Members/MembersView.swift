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
    @State var tappedMember = Member.empty
    @Binding var tabSelection: Int
    var body: some View {
        ScrollView {
            HStack {
                Text(house.name)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(
                                Color.gray.opacity(0.2)
                            )
                    )
                    //                        .padding(-10)
                    .padding()
                    .contextMenu(menuItems: {
                        Text("Tap to copy")
                        Button {
                            
                        } label: {
                            Text("ID: \(house.id)\nPassword: \(house.password)")
                        }
                        
                    })
                Spacer()
            }
            ForEach(house.members) { member in
                MemberCell(m: .constant(member))
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .onTapGesture {
                        //                                Fetch().getHouse(h: $house, inWR: .constant(false), noProf: .constant(false))
                        tappedMember = member
                        print(tappedMember)
                        if tappedMember.id == UserDefaults.standard.string(forKey: "myId")  {
                            tabSelection = 3
                        } else {
                            showDetails = true
                        }
                    }
            }
        }
        .onAppear(){
        }
        .sheet(isPresented: $showDetails, content: {
            MemberDetailsView(house: $house, member: $tappedMember, showView: $showDetails)
        })
    }
}

struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView(house: .constant(House.placeholder), tabSelection: .constant(0))
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

