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
    var body: some View {
        ScrollView {
                Text(h.name)
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
