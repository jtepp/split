//
//  TabsView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct TabsView: View {
    @Binding var tabSelection: Int
    @Binding var house: House
    @Binding var myId: String
    @Binding var inWR: Bool
    @Binding var noProf: Bool
    var body: some View {
        TabView(selection: $tabSelection,
                content:  {
                    ActivityView(house: $house, tabSelection: $tabSelection)
                        .tag(0)
                    MembersView(house: $house, tabSelection: $tabSelection)
                        .tag(1)
                    PaymentView(house: $house, tabSelection: $tabSelection)
                        .tag(2)
                    ProfileView(house: $house, m: .constant($house.members.wrappedValue.first(where: { (m) -> Bool in
                        return m.id == myId
                    }) ?? Member.empty), inWR: $inWR)
                        .tag(3)
                })
            .tabViewStyle(PageTabViewStyle())
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear(){
                Fetch().getHouse(h: $house, inWR: $inWR, noProf: $noProf)
            }
            .onChange(of: house.members.count, perform: { (_) in
                Fetch().getHouse(h: $house, inWR: $inWR, noProf: $noProf)
            })
            .sheet(isPresented: $inWR, onDismiss: {
                Fetch().getHouse(h: $house, inWR: $inWR, noProf: $noProf)
            }) {
                if (noProf) {
                NoProfileView(myId: $myId, show: $noProf, house: $house)
                        .background(Color.black.edgesIgnoringSafeArea(.all))
                        .allowAutoDismiss(false)
                } else {
                    WaitingRoomView(h: $house, inWR: $inWR, member: .constant(house.members.first ?? Member.empty))
                            .background(Color.black.edgesIgnoringSafeArea(.all))
                            .allowAutoDismiss(false)
                }
            }
            .onChange(of: tabSelection) { (_) in
                Fetch().getHouse(h: $house, inWR: $inWR, noProf: $noProf)
                if (UserDefaults.standard.string(forKey: "myId") ?? "") == "" || myId == "" {
                    Fetch().getHouse(h: $house, inWR: $inWR, noProf: $noProf)
                }
            }

    }
}
