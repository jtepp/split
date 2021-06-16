//
//  TabsView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct TabsView: View {
    @State var dontSplash = UserDefaults.standard.bool(forKey: "dontSplash")
    @Binding var tabSelection: Int
    @Binding var house: House
    @Binding var myId: String
    @Binding var inWR: Bool
    @Binding var noProf: Bool
    @Binding var showInvite: Bool
    @State var newGroup = ""
    @State var newPass = ""
    @State var newName = ""
    @State var member = Member.empty
    @State var showAlreadyGroup = false
    var body: some View {
        TabView(selection: $tabSelection,
                content:  {
                    ActivityView(house: $house, tabSelection: $tabSelection, inWR: $inWR, m: $member)
                        .tag(0)
                    MembersView(house: $house, tabSelection: $tabSelection)
                        .tag(1)
                    PaymentView(house: $house, tabSelection: $tabSelection)
                        .tag(2)
                    ProfileView(house: $house, m: .constant($house.members.wrappedValue.first(where: { (m) -> Bool in
                        return m.id == myId
                    }) ?? Member.empty), inWR: $inWR, showStatus: .constant($house.members.wrappedValue.first(where: { (m) -> Bool in
                        return m.id == myId
                    })?.showStatus ?? true))
                    .tag(3)
                })
            .tabViewStyle(PageTabViewStyle())
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear(){
                Fetch().getHouse(h: $house, inWR: $inWR, noProf: $noProf)
            }
            .onChange(of: inWR, perform: { (_) in
                //                print("WAITING ROOM CHANGED \n\n\(member)\n\n\n\n\n")
                if inWR && !showInvite {
                    member = .empty
                    house = .empty
                }
                noProf = member.id == ""
            })
            .sheet(isPresented: $inWR, onDismiss: {
                Fetch().getHouse(h: $house, inWR: $inWR, noProf: $noProf)
            }) {
                if (dontSplash) {
                    if showInvite {
                        LinkInviteView(inWR: $inWR, showInvite: $showInvite, h: $house, m: $member, newGroup: $newGroup, newPass: $newPass, newName: $newName)
                            .background(Color.black.edgesIgnoringSafeArea(.all))
                            .allowAutoDismiss(false)
                    }
                    else if (noProf) {
                        NoProfileView(m: $member, myId: $myId, show: $noProf, house: $house)
                            .background(Color.black.edgesIgnoringSafeArea(.all))
                            .allowAutoDismiss(false)
                    } else {
                        WaitingRoomView(h: $house, inWR: $inWR, noProf: $noProf, member: $member)
                            .background(Color.black.edgesIgnoringSafeArea(.all))
                            .allowAutoDismiss(false)
                    }
                } else {
                    SplashView(dontSplash: $dontSplash, showSplash: .constant(false))
                        .padding()
                        .background(Color.black.edgesIgnoringSafeArea(.all))
                        .allowAutoDismiss(false)
                        .animation(Animation.easeIn.speed(3))
                }
            }
            .onOpenURL{ url in
                let link = url.absoluteString.components(separatedBy: "//")[1]
                newGroup = String(link.split(separator: "$")[0])
                newPass = String(link.split(separator: "$")[1])
                Fetch().groupNameFromId(id: String(newGroup), nn:$newName)
                if newGroup == house.id {
                    showAlreadyGroup = true
                } else {
                    showInvite = true
                    inWR = true
                }
            }
            .alert(isPresented: $showAlreadyGroup, content: {
                Alert(title: Text("Already in this group"), message: Text("You are already a member of the group you are trying to join"), dismissButton: Alert.Button.default(Text("Ok")))
            })
        //            .onChange(of: tabSelection) { (_) in
        //                Fetch().getHouse(h: $house, inWR: $inWR, noProf: $noProf)
        //            }
        
    }
}
