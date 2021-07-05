//
//  Main.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-24.
//

import SwiftUI
import WidgetKit

struct Main: View {
    @Environment(\.scenePhase) var scenePhase
    @State var h = House.empty
    @State var m = Member.empty
    @State var inWR = ((UserDefaults.standard.value(forKey: "houseId") as? String ?? ""  == "waitingRoom") || (UserDefaults.standard.value(forKey: "houseId") as? String ?? ""  == "")) 
    @State var noProf = true
    @State var myId = UserDefaults.standard.string(forKey: "myId") ?? ""
    @State var tabSelection = 0
    @State var dontSplash = UserDefaults.standard.bool(forKey: "dontSplash")
    @State var engaged = false
    @State var watch = 0
    var body: some View {
        ZStack {
            TabsView(tabSelection: $tabSelection, house: $h, member: $m, myId: $myId, inWR: $inWR, noProf: $noProf, engaged: $engaged, watch: $watch)
                .animation(.easeOut)
            //                .onAppear{
            //                    print("\n\n\n\n\ntrue\n\n\n\n\n\n")
            //                }
            //                .onDisappear{
            //                    print("\n\n\n\n\nfalse\n\n\n\n\n\n")
            //                }
            TabBar(tabSelection: $tabSelection, engaged: $engaged, watch: $watch)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear{
            Fetch().getHouse(h: $h, m: $m, inWR: $inWR, noProf: $noProf)
        }
        .onChange(of: h.id, perform: { _ in
            //            inWR = false
            //            noProf = false
            //            UserDefaults.standard.set("SIfrfcT2735XvpRCB714", forKey: "myId")
            //            UserDefaults.standard.set("TlRWEGz9GWrKBXqI9T8L", forKey: "houseId")
            //            myId = "SIfrfcT2735XvpRCB714"
            //            h.id = "TlRWEGz9GWrKBXqI9T8L"
            Fetch().getHouse(h: $h, m: $m, inWR: $inWR, noProf: $noProf)
        })
        .onChange(of: scenePhase) { newPhase in
            
            if (UserDefaults.standard.string(forKey: "myId") ?? "") != "" {
                if newPhase == .inactive {
                    Fetch().updateStatus(status: false)
                    Fetch().balanceWidgetMembers(myName: m.name, myId: m.id, houseId: h.id)
                    WidgetCenter.shared.reloadAllTimelines()
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
                    Fetch().balanceWidgetMembers(myName: m.name, myId: m.id, houseId: h.id)
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
        }
        .sheet(isPresented: $inWR, onDismiss: {
            Fetch().getHouse(h: $h, m: $m, inWR: $inWR, noProf: $noProf)
        }) {
            if (dontSplash) {
            if (noProf) {
                NoProfileView(m: $m, myId: $myId, show: $noProf, house: $h)
                    .background(Color.black.edgesIgnoringSafeArea(.all))
                    .allowAutoDismiss(false)
            } else {
                WaitingRoomView(h: $h, inWR: $inWR, noProf: $noProf, member: $m)
                        .background(Color.black.edgesIgnoringSafeArea(.all))
                        .allowAutoDismiss(false)
            }
            } else {
                SplashView(dontSplash: $dontSplash, showSplash: .constant(false))
                    .padding()
                    .background(Color.black.edgesIgnoringSafeArea(.all))
                    .allowAutoDismiss(false)
                    .animation(Animation.easeIn.speed(3))
            }
        }
        .animation(Animation.easeIn.speed(3))
    }
}

struct Main_Previews: PreviewProvider {
    static var previews: some View {
        Main()
    }
}
