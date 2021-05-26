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
    @Binding var members: [Member]
    var body: some View {
        TabView(selection: $tabSelection,
                content:  {
                    ActivityView()
                        .tag(0)
                    MembersView(members: $members)
                        .tag(1)
                    PaymentView()
                        .tag(2)
                    ProfileView()
                        .tag(3)
                })
            .tabViewStyle(PageTabViewStyle())
    }
}
