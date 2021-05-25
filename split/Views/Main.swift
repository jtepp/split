//
//  Main.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-24.
//

import SwiftUI

struct Main: View {
    @ObservedObject var fetch = Fetch()
    @State var houses = [House]()
    var body: some View {
        ScrollView {
            ForEach(houses){ h in
                Text(h.name)
            }
        }
        .onAppear{
            fetch.updateHouses(h: $houses)
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
