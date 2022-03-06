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
    @State var inWR = ((UserDefaults.standard.string(forKey: "houseId") ?? "")  == "waitingRoom") || ((UserDefaults.standard.string(forKey: "houseId") ?? "") == "")
    @State var noProf = true
    @State var myId = UserDefaults.standard.string(forKey: "myId") ?? ""
    @State var tabSelection = 0
    @State var dontSplash = UserDefaults.standard.bool(forKey: "dontSplash")
    @State var engaged = false
    @State var watch = 0 //profile
    @ObservedObject var refresh = RefreshObject()
    var body: some View {
        ZStack {
            TabsView(tabSelection: $tabSelection, house: $h, member: $m, myId: $myId, inWR: $inWR, noProf: $noProf, engaged: $engaged, watch: $watch, refresh: refresh)
//                .animation(.easeOut)

            TabBar(tabSelection: $tabSelection, engaged: $engaged, watch: $watch, refresh: refresh)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear{
            Fetch().getHouse(h: $h, m: $m, inWR: $inWR, noProf: $noProf)
        }
        .onChange(of: h.id, perform: { _ in
            Fetch().getHouse(h: $h, m: $m, inWR: $inWR, noProf: $noProf)
        })
        .onChange(of: scenePhase) { newPhase in
            
            if (UserDefaults.standard.string(forKey: "myId") ?? "") != "" {
                if newPhase == .inactive {
                    Fetch().updateStatus(status: false)
//                    Fetch().balanceWidgetMembers(myName: m.name, myId: m.id, houseId: h.id)
                    WidgetCenter.shared.reloadAllTimelines()
                } else if newPhase == .active {
                    Fetch().updateStatus(status: true)
                    guard let name = shortcutItemToProcess?.localizedTitle else {
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
//                    Fetch().balanceWidgetMembers(myName: m.name, myId: m.id, houseId: h.id)
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
