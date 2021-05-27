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
    var body: some View {
        TabView(selection: $tabSelection,
                content:  {
                    ActivityView(house: $house)
                        .tag(0)
                    MembersView(house: $house)
                        .tag(1)
                    PaymentView(house: $house, tabSelection: $tabSelection)
                        .tag(2)
                    ProfileView(house: $house, m: .constant($house.members.wrappedValue.first(where: { (m) -> Bool in
                        return m.id == myId
                    }) ?? Member.empty))
                        .tag(3)
                })
            .tabViewStyle(PageTabViewStyle())
    }
}
