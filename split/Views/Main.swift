//
//  Main.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-24.
//

import SwiftUI

struct Main: View {
    @ObservedObject var fetch = Fetch()
    @State var h = House.empty
    @State var id = "TlRWEGz9GWrKBXqI9T8L"
    @State var tabSelection = 0
    @State var test = 0
    var body: some View {
        ZStack {
            TabsView(tabSelection: $tabSelection)
                .animation(.easeOut)
                .onChange(of: tabSelection, perform: { _ in
                    print(test)
                })
            TabBar(tabSelection: $tabSelection)
        }
        .onAppear{
            fetch.getHouse(h: $h, id: id)
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
