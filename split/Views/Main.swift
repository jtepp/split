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
    @State var test = 33
    var body: some View {
        TabView(selection: $tabSelection,
                content:  {
                    Text("Tab Content \(test)")
                        .tabItem    {
                            Image(systemName: "arrow.clockwise")
                            Text("Tab Label 1")
                        }
                        .tag(1)

                    Text("Tab Content \(test)")
                        .tabItem    {
                            Text("Tab Label 2")
                        }
                        .tag(2)
                })
            .tabViewStyle(PageTabViewStyle())
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
