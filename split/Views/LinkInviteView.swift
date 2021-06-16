//
//  LinkInviteView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-06-15.
//

import SwiftUI

struct LinkInviteView: View {
    @Binding var inWR: Bool
    @Binding var showInvite: Bool
    @Binding var h: House
    @Binding var m: Member
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
            //            .frame(maxHeight: 300)
            .padding()
            //            .padding(.bottom, 10)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        Color.white.opacity(0.2)
                    )
            )
            .padding(.vertical)
            Spacer()
            Button(action: {
                tapped = true
                UserDefaults.standard.setValue(true, forKey: "inv")
                /**** not in house ****/
                if h.id == "" {
                    //if no my id
                    if m.id == "" {
                        showEdit = true
                        showSheet = true
                        /*
                         - open account maker to set to $m, join house on accept
                         */
                        
                        
                        
                    } else {
                        //if has id (easy)
                        /*
                         - join!
                         */
                        Fetch().joinHouse(hh: $h, m: $m, hId: newGroup, password: newPass, showAlert: $showAlert, tapped: $tapped, msg: $msg, inWR: $inWR)
                        
                    }
                    
                    /****in house ****/
                } else {
                    if !m.admin {
                        Fetch().joinHouse(hh: $h, m: $m, hId: newGroup, password: newPass, showAlert: $showAlert, tapped: $tapped, msg: $msg, inWR: $inWR, deleteFromHere: h.id)
                        //not admin
                        /*
                         - duplicate into other house, set UD, delete old
                         */} else {
                            //if ur only one
                            if h.members.count == 1 {
                                Fetch().joinHouse(hh: $h, m: $m, hId: newGroup, password: newPass, showAlert: $showAlert, tapped: $tapped, msg: $msg, inWR: $inWR, deleteFromHere: h.id)
                            } else {
                                showAlert = true
                                msg = "You have to choose a new Group admin before you leave"
                                
                                //if already in house and admin
                                /*
                                 - set new admin then on dismiss...
                                 - duplicate into other house, set UD, delete old
                                 */}
                            
                         }
                }
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
                .padding()
            })
            .disabled(tapped)
            Button(action: {
                //                inWR = false
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
                        .fill(Color.white.opacity(0.2))
                )
                .padding(.horizontal)
                .padding(.bottom)
            })
        }
        .alert(isPresented: $showAlert, content: {
            if msg == "You have to choose a new Group admin before you leave" {
                return Alert(title: Text("Choose Admin"), message: Text(msg), primaryButton: Alert.Button.destructive(Text("Ok"), action: {
                    showSheet = true
                    showEdit = false
                }), secondaryButton: Alert.Button.cancel())
            } else {
                return Alert(title: Text("Error joining group"), message: Text(msg))
            }
        })
        .sheet(isPresented: $showSheet, onDismiss: {
            if !choice.isEmpty {
                Fetch().swapAdmin(m: choice.first!, h: h)
            }
            Fetch().joinHouse(hh: $h, m: $m, hId: newGroup, password: newPass, showAlert: $showAlert, tapped: $tapped, msg: $msg, inWR: $inWR)
        }, content: {
            if showEdit {
                NoProfileView(m: $m, myId: .constant(""), show: $showSheet, house: $h)
                    .background(Color.black.edgesIgnoringSafeArea(.all))
                    .allowAutoDismiss(false)
            } else {
                MemberPicker(show: $showSheet, house: $h, choice: $choice)
                    .background(Color.black.edgesIgnoringSafeArea(.all))
                    .allowAutoDismiss(false)
            }
        })
        .onAppear{
            Fetch().returnMembers(hId: newGroup, nm: $newMembers)
            if newName == "err" {
                showInvite = false
            }
        }
    }
}

struct LinkInviteView_Previews: PreviewProvider {
    static var previews: some View {
        LinkInviteView(inWR: .constant(true), showInvite: .constant(true), h: .constant(.placeholder), m: .constant(.placeholder), newGroup: .constant("x9vd0sduWMWT5Zv1FTAD"), newPass: .constant("pass"), newName: .constant("name"), newMembers: [.empty])
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
