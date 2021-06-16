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
    @Binding var member: Member
    @Binding var myId: String
    @Binding var inWR: Bool
    @Binding var noProf: Bool
    @Binding var showInvite: Bool
    var body: some View {
        TabView(selection: $tabSelection,
                content:  {
                    ActivityView(house: $house, tabSelection: $tabSelection, inWR: $inWR, m: $member)
                        .tag(0)
                    MembersView(house: $house, tabSelection: $tabSelection)
                        .tag(1)
                    PaymentView(house: $house, tabSelection: $tabSelection)
                        .tag(2)
                    ProfileView(house: $house, m: member.id == "" ? .constant($house.members.wrappedValue.first(where: { (m) -> Bool in
                                    return m.id == myId
                                            }) ?? Member.empty) : $member, inWR: $inWR, showStatus: .constant($house.members.wrappedValue.first(where: { (m) -> Bool in
                        return m.id == myId
                    })?.showStatus ?? true), noProf: $noProf, showInvite: $showInvite)
                    .tag(3)
                })
            .tabViewStyle(PageTabViewStyle())
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear(){
                Fetch().getHouse(h: $house, inWR: $inWR, noProf: $noProf)
            }
            .onChange(of: inWR, perform: { (_) in
                //                print("WAITING ROOM CHANGED \n\n\(member)\n\n\n\n\n")
                if inWR && noProf {
                    member = .empty
                    house = .empty
                }
                noProf = member.id == ""
            })
            .sheet(isPresented: $inWR, onDismiss: {
                Fetch().getHouse(h: $house, inWR: $inWR, noProf: $noProf)
            }) {
                if (dontSplash) {
                    if (noProf) {
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
        //            .onChange(of: tabSelection) { (_) in
        //                Fetch().getHouse(h: $house, inWR: $inWR, noProf: $noProf)
        //            }
        
    }
}
