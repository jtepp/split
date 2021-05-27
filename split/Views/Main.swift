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
    @State var inWR = true
    @State var noProf = true
    @State var myId = UserDefaults.standard.string(forKey: "myId") ?? ""
    @State var tabSelection = 0
    var body: some View {
        ZStack {
            TabsView(tabSelection: $tabSelection, house: $h, myId: $myId)
                .animation(.easeOut)
            TabBar(tabSelection: $tabSelection)
                .sheet(isPresented: $inWR) {
                    ModalView(title: "Sign in") { //in waiting room with id
                        if !noProf && myId != "" {
                            WaitingRoomView(show: $inWR)
                        }
                    }
                    .background(Color.black.edgesIgnoringSafeArea(.all))
                }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear{
            fetch.getHouse(h: $h, inWR: $inWR, noProf: $noProf)
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
