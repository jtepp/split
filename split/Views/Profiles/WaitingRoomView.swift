//
//  WaitingRoomView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-27.
//

import SwiftUI

struct WaitingRoomView: View {
    @Binding var h: House
    @Binding var inWR: Bool
    @Binding var noProf: Bool
    @Binding var member: Member
    @State var showPanel = 0
    @State var hId = ""
    @State var hNm = ""
    @State var hPw = ""
    @State var msg = "Error joining group"
    @State var showWrongPassAlert = false
    @State var tapped = false
    var body: some View {
        VStack{
            ZStack {
                Spacer(minLength: 260)
                    .overlay(
                        ZStack {
                            Image("Name")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 400)
                                .opacity(showPanel == 0 ? 1 : 0)
                            VStack {
                                InputField(name: "Group \(showPanel == 1 ? "ID" : "Name")", text: $hId, small: true)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                InputField(name: "Password", text: $hPw, small: true)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .onChange(of: hPw, perform: { _ in
                                        hPw = hPw.replacingOccurrences(of: "$", with: "")
                                    })
                                Button(action: {
                                    tapped = true
                                    if showPanel == 1 {
                                        Fetch().joinHouse(hh: $h, m: $member, hId: hId, password: hPw, showAlert: $showWrongPassAlert, tapped: $tapped, msg: $msg, inWR: $inWR)
                                    } else if showPanel == 2 {
                                        Fetch().createHouse(hh: $h, m: $member, name: hId, password: hPw, tapped: $tapped, inWR: $inWR)
                                    }
                                }, label: {
                                    HStack {
                                        //                                        Spacer()
                                        Text(showPanel == 1 ? "Join" : showPanel == 2 ? "Create" : "")
                                            .foregroundColor(.white)
                                        //                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill((tapped || hId.isEmpty || hPw .isEmpty) ? Color.gray : Color.blue)
                                    )
                                    .padding()
                                })
                                .disabled(tapped || hId.isEmpty || hPw .isEmpty)
                            }
                            .opacity(showPanel != 0 ? 1 : 0)
                            .allowsHitTesting(showPanel != 0)
                            .offset(y: 40)
                        }
                        
                        .animation(Animation.easeIn.speed(3))
                    )
            }
            Button(action: {
                if showPanel == 1 {
                    showPanel = 0
                } else {
                    showPanel = 1
                }
                hId = ""
                hPw = ""
            }, label: {
                HStack {
                    Spacer()
                    Text("Join a Group")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                )
                .padding()
            })
            .padding()
            
            Button(action: {
                if showPanel == 2 {
                    showPanel = 0
                } else {
                    showPanel = 2
                }
                hId = ""
                hPw = ""
            }, label: {
                HStack {
                    Spacer()
                    Text("Create a Group")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.blue)
                )
                .padding()
            })
            .padding()
            
            Spacer()
                .alert(isPresented: $showWrongPassAlert, content: {
                    Alert(title: Text(msg), message: Text("Please make sure you put in your information correctly and try again"), dismissButton: Alert.Button.default(Text("Ok"), action: {
                        if msg == "Member already exists by that name" {
                            UserDefaults.standard.set("", forKey: "myId")
                            UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("", forKey: "myId")
                            UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("", forKey: "myName")
                            UserDefaults.standard.set("", forKey: "houseId")
                            UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("", forKey: "houseId")
                            member = .empty
                            h = .empty
                            inWR = true
                            noProf = true
                            UserDefaults.standard.set(true, forKey: "noProf")
                        }
                    }))
                })
        }
    }
}

//struct WaitingRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        WaitingRoomView(member: .constant(.placeholder))
//            .background(Color.black.edgesIgnoringSafeArea(.all))
//    }
//}
