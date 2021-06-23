//
//  MembersView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI
import MobileCoreServices

struct MembersView: View {
    @Binding var house: House
    @State var showDetails = false
    @State var tappedMember = Member.empty
    @Binding var tabSelection: Int
    @State var showRemove = false
    @State var showAlert = false
    var body: some View {
        ScrollView {
            HStack {
                Text(house.name)
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .bold()
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                Color.gray.opacity(0.2)
                            )
                    )
                    //                        .padding(-10)
                    .padding()
                    .contextMenu(menuItems: {
                        Button {
                            UIPasteboard.general.string = "Join my group on spllit!\nspllit://\(house.id)$\(house.password)"
                        } label: {
                            Text("Copy group invite")
                            Image(systemName: "link.circle")
                        }
                        Button {
                            UIPasteboard.general.string = "\(house.id)"
                        } label: {
                            Text("Copy group ID")
                            Image(systemName: "doc.on.doc")
                            
                        }
                        
                        Text("Password: \(house.password)")
                        
                    })
                Spacer()
            }
            ForEach(house.members) { member in
                if member.id != UserDefaults.standard.string(forKey: "myId") && house.members.first(where: { mr in
                    return mr.id == UserDefaults.standard.string(forKey: "myId")
                })?.admin ?? false {
                    MemberCell(m: .constant(member))
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .contextMenu(menuItems: {
                            Button {
                                tappedMember = member
                                showAlert = true
                                showRemove = false
                            } label: {
                                Text("Set as admin")
                                Image(systemName: "crown")
                            }
                            Button {
                                tappedMember = member
                                showAlert = true
                                showRemove = true
                            } label: {
                                Text("Remove from group")
                                Image(systemName: "person.badge.minus")
                            }
                            
                        })
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
                } else {
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
            Rectangle()
                .fill(Color.black)
                .frame(minHeight:120)
        }
        .onAppear(){
        }
        .sheet(isPresented: $showDetails, content: {
            MemberDetailsView(house: $house, member: $tappedMember, showView: $showDetails)
        })
        .alert(isPresented: $showAlert, content: {
            if showRemove {
                return Alert(title: Text("Remove \(tappedMember.name)"), message: Text("Are you sure you want to remove \(tappedMember.name) from this group?"), primaryButton: Alert.Button.destructive(Text("Confirm"), action: {
                    Fetch().removeMember(m: tappedMember, h: $house)
                    Fetch().getHouse(h: $house, m: .constant(tappedMember), inWR: .constant(false), noProf: .constant(false))
                }), secondaryButton: Alert.Button.cancel())
            
        } else {
            return Alert(title: Text("Set \(tappedMember.name) as Group admin"), message: Text("Are you sure you want to set \(tappedMember.name) as the new Group admin? This change can only be reverted by the new admin"), primaryButton: Alert.Button.destructive(Text("Confirm"), action: {
                Fetch().swapAdmin(m: tappedMember, h: house)
            }), secondaryButton: Alert.Button.cancel())
        }
        })
    }
}

struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView(house: .constant(House.placeholder), tabSelection: .constant(0))
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

