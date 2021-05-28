//
//  Main.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-24.
//

import SwiftUI

struct Main: View {
    @State var h = House.empty
    @State var inWR = ((UserDefaults.standard.value(forKey: "houseId") as? String ?? ""  == "waitingRoom") || (UserDefaults.standard.value(forKey: "houseId") as? String ?? ""  == "")) 
    @State var noProf = true
    @State var myId = UserDefaults.standard.string(forKey: "myId") ?? ""
    @State var tabSelection = 0
    var body: some View {
        ZStack {
            TabsView(tabSelection: $tabSelection, house: $h, myId: $myId, inWR: $inWR, noProf: $noProf)
                .animation(.easeOut)
            TabBar(tabSelection: $tabSelection)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear{
            Fetch().getHouse(h: $h, inWR: $inWR, noProf: $noProf)
        }
        .onChange(of: h.id, perform: { _ in
            inWR = false
            noProf = false
//            UserDefaults.standard.set(myId, forKey: "myId")
            UserDefaults.standard.set("SIfrfcT2735XvpRCB714", forKey: "myId")
            UserDefaults.standard.set("TlRWEGz9GWrKBXqI9T8L", forKey: "houseId")
            myId = "SIfrfcT2735XvpRCB714"
            h.id = "TlRWEGz9GWrKBXqI9T8L"
            Fetch().getHouse(h: $h, inWR: $inWR, noProf: $noProf)
        })
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
