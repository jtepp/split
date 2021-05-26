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
    var body: some View {
        TabView(selection: $tabSelection,
                content:  {
                    ActivityView(house: $house)
                        .tag(0)
                    MembersView(house: $house)
                        .tag(1)
                    PaymentView()
                        .tag(2)
                    ProfileView()
                        .tag(3)
                })
            .tabViewStyle(PageTabViewStyle())
    }
}