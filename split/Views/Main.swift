//
//  Main.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-24.
//

import SwiftUI

struct Main: View {
    @Environment(\.scenePhase) var scenePhase
    @State var h = House.empty
    @State var inWR = ((UserDefaults.standard.value(forKey: "houseId") as? String ?? ""  == "waitingRoom") || (UserDefaults.standard.value(forKey: "houseId") as? String ?? ""  == "")) 
    @State var noProf = true
    @State var myId = UserDefaults.standard.string(forKey: "myId") ?? ""
    @State var tabSelection = 0
    @State var title = ""
    @State var msg = ""
    @State var showLinkAlert = false
    @State var newName = ""
    var body: some View {
        ZStack {
            TabsView(tabSelection: $tabSelection, house: $h, myId: $myId, inWR: $inWR, noProf: $noProf)
                .animation(.easeOut)
            //                .onAppear{
            //                    print("\n\n\n\n\ntrue\n\n\n\n\n\n")
            //                }
            //                .onDisappear{
            //                    print("\n\n\n\n\nfalse\n\n\n\n\n\n")
            //                }
            TabBar(tabSelection: $tabSelection)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear{
            
            Fetch().getHouse(h: $h, inWR: $inWR, noProf: $noProf)
        }
        .onChange(of: h.id, perform: { _ in
            //            inWR = false
            //            noProf = false
            //            UserDefaults.standard.set("SIfrfcT2735XvpRCB714", forKey: "myId")
            //            UserDefaults.standard.set("TlRWEGz9GWrKBXqI9T8L", forKey: "houseId")
            //            myId = "SIfrfcT2735XvpRCB714"
            //            h.id = "TlRWEGz9GWrKBXqI9T8L"
            Fetch().getHouse(h: $h, inWR: $inWR, noProf: $noProf)
        })
        .onChange(of: scenePhase) { newPhase in
            
            if (UserDefaults.standard.string(forKey: "myId") ?? "") != "" {
                if newPhase == .inactive {
                    Fetch().updateStatus(status: false)
                } else if newPhase == .active {
                    Fetch().updateStatus(status: true)
                    guard let name = shortcutItemToProcess?.localizedTitle as? String else {
                        print("else")
                        return
                    }
                    switch name {
                    case "Send payment":
                        tabSelection = 2
                    case "Send request":
                        tabSelection = 2
                    default:
                        tabSelection = 0
                    }
                } else if newPhase == .background {
                    Fetch().updateStatus(status: false)
                }
            }
        }
        .onOpenURL{ url in
            print("AAAAAAAAAAAAA")
            let link = url.absoluteString.components(separatedBy: "//")[1]
            let newGroup = link.split(separator: "$")[0]
            let newPass = link.split(separator: "$")[1]
            
            let oldGroup = h.id
            let oldID = UserDefaults.standard.string(forKey: "myId") ?? ""
            
            Fetch().groupNameFromId(id: String(newGroup), nn:$newName)
            
//            print("asef \(newName)")
            
            if oldID == "" {
            
            if oldGroup == newGroup {
                title = "Already in this group"
                msg = "You are already a member of the group you are trying to join"
            }
            } else {
                title = "Already in a group"
                msg = "You are already in another group. Please delete this account from the profile page to "
            }
            
        }
        .alert(isPresented: $showLinkAlert) {
            Alert(title: Text(newName), message: Text(msg), primaryButton: Alert.Button.default(Text("Join"), action: {
                
            }), secondaryButton: Alert.Button.cancel())
        }
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
