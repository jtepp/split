//
//  LinkInviteView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-06-15.
//

import SwiftUI

struct LinkInviteView: View {
    @Binding var inWR: Bool
    @Binding var noProf: Bool
    @Binding var showInvite: Bool
    @Binding var h: House
    @Binding var m: Member
    @Binding var myId: String
    @Binding var newGroup: String
    @Binding var newPass: String
    @Binding var newName: String
    @State var showAlert = false
    @State var tapped = false
    @State var newMembers = [Member]()
    @State var msg = ""
    @State var showEdit = false
    @State var showSheet = false
    @State var choice = [Member]()
    var body: some View {
        VStack{
            HeaderText(text: "Invitation to join")
            HStack {
                Text(newName)
                    .font(Font.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                Color.gray.opacity(0.2)
                            )
                    )
                
                Spacer()
            }
            .padding(.leading)
            .padding(.top, -20)
            Spacer()
            ScrollView {
                ForEach(newMembers) { member in
                    MemberCell(m: .constant(member))
                }
            }
                        .frame(maxHeight: 400)
            .padding()
            //            .padding(.bottom, 10)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        Color("DarkMaterial")
                    )
            )
            .padding(.vertical)
            Spacer()
            
            VStack {
                Button(action: {
//                    showInvite = false
//                    showAlert = true
//                    print("SDFSDFSDSDFSDF\(showAlert)")
                    tapped = true
                    
//                    if h.id == "" || h.id == "waitingRoom" {
                        if noProf {
                            print("noprof inv")
                            showSheet = true
                            showEdit = true
                        } else {
                            print("SDFSDFSDDFSFDFS\(m.admin)")
                            // if admin and house has more, show switch
                            Fetch().getHouse(h: $h, m: $m, inWR: $inWR, noProf: $noProf)
                            if h.members.count > 1 {
                                if m.admin {
                                    msg = "You have to choose a new Group Admin before you leave"
                                    showAlert = true
                                    print("COUNTERHERE \(h.members.count)")
                                } else {
                                    transfer(m: $m, h: $h, myId: $myId, newGroup: newGroup, newPass: newPass, showAlert: $showAlert, tapped: $tapped, msg: $msg, inWR: $inWR, noProf: $noProf, showInvite: $showInvite)
                                }
                            } else {
                                transfer(m: $m, h: $h, myId: $myId, newGroup: newGroup, newPass: newPass, showAlert: $showAlert, tapped: $tapped, msg: $msg, inWR: $inWR, noProf: $noProf, showInvite: $showInvite)
                            }
                        }
//                    } else {
//                        
//                        if noProf {
//                            print("noprof inv")
//                            Fetch().checkSwitch(h: $h, m: $m, newGroup: newGroup, newPass: newPass, showAlert: $showAlert, tapped: $tapped, msg: $msg, inWR: $inWR, noProf: $noProf, showInvite: $showInvite){ go in
//                                print("gogogo\(go)")
//                            }
////                            showSheet = true
////                            showEdit = true
//                        }
////                        else {
////                            print("SDFSDFSDDFSFDFS\(m.admin)")
////                            // if admin and house has more, show switch
////                            if h.members.count > 1 {
////                                if m.admin {
////                                    msg = "You have to choose a new Group Admin before you leave"
////                                    showAlert = true
////                                    print("COUNTERHERE \(h.members.count)")
////                                } else {
////                                    transfer(m: $m, h: $h, myId: $myId, newGroup: newGroup, newPass: newPass, showAlert: $showAlert, tapped: $tapped, msg: $msg, inWR: $inWR, noProf: $noProf, showInvite: $showInvite)
////                                }
////                            } else {
////                                transfer(m: $m, h: $h, myId: $myId, newGroup: newGroup, newPass: newPass, showAlert: $showAlert, tapped: $tapped, msg: $msg, inWR: $inWR, noProf: $noProf, showInvite: $showInvite)
////                            }
////                        }
//                        
//                    }
                    
            }, label: {
                HStack {
                    Spacer()
                    Text("Join")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(tapped ? Color.gray : Color.blue)
                )
            })
            .disabled(tapped)
            
            Button(action: {
                showInvite = false
            }, label: {
                HStack {
                    Spacer()
                    Text("Cancel")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            Color("DarkMaterial")
                        )
                )
//                .padding(.horizontal)
//                .padding(.bottom)
            })
                
            }
            .padding()
        }
        .alert(isPresented: $showAlert, content: {
            if msg == "You have to choose a new Group Admin before you leave" {
                return Alert(title: Text("Choose Admin"), message: Text(msg), primaryButton: Alert.Button.destructive(Text("Choose Admin"), action: {
                    showSheet = true
                    showEdit = false
                }), secondaryButton: Alert.Button.cancel())
            } else {
                return Alert(title: Text("Error joining group"), message: Text(msg), dismissButton: Alert.Button.default(Text("Ok"), action: {
                    showInvite = false
                }))
            }
        })
        .sheet(isPresented: $showSheet, onDismiss: {
            if !choice.isEmpty {
                Fetch().swapAdmin(m: choice.first!, h: h) {
                    transfer(m: $m, h: $h, myId: $myId, newGroup: newGroup, newPass: newPass, showAlert: $showAlert, tapped: $tapped, msg: $msg, inWR: $inWR, noProf: $noProf, showInvite: $showInvite)
                }
            } else {
                Fetch().switchToHouse(h: $h, m: $m, newGroup: newGroup, newPass: newPass, showAlert: $showAlert, tapped: $tapped, msg: $msg, inWR: $inWR, noProf: $noProf, showInvite: $showInvite)
            }
            showInvite = false
        }, content: {
            if showEdit {
                NoProfileView(m: $m, myId: $myId, show: $showSheet, house: $h, newMembers: newMembers.map({ member in
                    return member.name
                }))
                    .background(Color.black.edgesIgnoringSafeArea(.all))
                    .allowAutoDismiss(false)
            } else {
                MemberPicker(show: $showSheet, house: $h, choice: $choice)
                    .background(Color.black.edgesIgnoringSafeArea(.all))
                    .allowAutoDismiss(false)
            }
        })
        .onAppear{
            tapped = false
            print("LINKPEAR\(m.name)\n\n")
            Fetch().returnMembers(hId: newGroup, nm: $newMembers, msg: $msg, showAlert: $showAlert)
        }
        .onChange(of: newName, perform: { _ in
            if newName == "err" {
                msg = "Group not found"
                showAlert = true
            }
        })
    }
}

struct LinkInviteView_Previews: PreviewProvider {
    static var previews: some View {
        LinkInviteView(inWR: .constant(true), noProf: .constant(false), showInvite: .constant(true), h: .constant(.placeholder), m: .constant(.placeholder), myId: .constant(""), newGroup: .constant("x9vd0sduWMWT5Zv1FTAD"), newPass: .constant("pass"), newName: .constant("name"), newMembers: [.empty])
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}


func transfer(m: Binding<Member>, h: Binding<House>, myId: Binding<String>, newGroup: String, newPass: String, showAlert: Binding<Bool>, tapped: Binding<Bool>, msg: Binding<String>, inWR: Binding<Bool>, noProf: Binding<Bool>, showInvite: Binding<Bool>) {
    
    Fetch().checkSwitch(h: h.wrappedValue, m: m, newGroup: newGroup, newPass: newPass, showAlert: showAlert, tapped: tapped, msg: msg, inWR: inWR, noProf: noProf, showInvite: showInvite){ go in
        print("OGOGOGO\(go)")
        if go {
//            Fetch().deleteAccount(m: .constant(m.wrappedValue), inWR: .constant(false)){
            
//            let home = m.wrappedValue.home
//            let id = m.wrappedValue.id
//            let name = m.wrappedValue.name
//            let bm = Member(id: id, home: home, name: name, image: "", showStatus: false)
            
            Fetch().switchToHouseTwo(h: h, m: m, newGroup: newGroup, newPass: newPass, showAlert: showAlert, tapped: tapped, msg: msg, inWR: inWR, noProf: noProf, showInvite: showInvite)
//            }
        } 
    }
    
//    Fetch().deleteAccount(m: .constant(m.wrappedValue), erase: true, inWR: inWR) {
    
//        h.wrappedValue = .empty
//        let mmm = m.wrappedValue
//        h.wrappedValue.members.append(m.wrappedValue)
//        Fetch().addToWR(m: m, myId: myId, h: h){

//            Fetch().switchToHouse(h: h, m: m, newGroup: newGroup, newPass: newPass, showAlert: showAlert, tapped: tapped, msg: msg, inWR: inWR, noProf: noProf, showInvite: showInvite)
        
//    }
    
}
