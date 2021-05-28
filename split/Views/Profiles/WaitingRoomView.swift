//
//  WaitingRoomView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-27.
//

import SwiftUI

struct WaitingRoomView: View {
    @Binding var member: Member
    @State var showPanel = 0
    @State var hId = ""
    @State var hNm = ""
    @State var hPw = ""
    @State var showWrongPassAlert = false
    @State var tapped = false
    var body: some View {
        VStack{
            ZStack {
                Spacer()
                    .overlay(
                        ZStack {
                            Image("Name")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 400)
                                .opacity(showPanel == 0 ? 1 : 0)
                            VStack {
                                InputField(name: "House \(showPanel == 1 ? "ID" : "Name")", text: $hId)
                                InputField(name: "Password", text: $hPw)
                                Button(action: {
                                    tapped = true
                                    if showPanel == 1 {
                                        Fetch().joinHouse(m: $member, hId: hId, password: hPw, showAlert: $showWrongPassAlert, tapped: $tapped)
                                        ///look in houses for id, if not found call error, if found and bad pwd call error, if found and good pwd ->
                                        ///put in update location, refresh house, later add announcement
                                    } else if showPanel == 2 {
                                        //                                        Fetch().createHouse(m: $member, name: String, password: String)
                                        ///put in new location and make admin, refresh house stuff
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
                                .disabled(tapped)
                            }
                            .opacity(showPanel != 0 ? 1 : 0)
                            .allowsHitTesting(showPanel != 0)
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
                    Text("Join a House")
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
                    Text("Create a House")
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
                    Alert(title: Text("Error joining house"), message: Text("Please make sure you put in your information correctly and try again"), dismissButton: Alert.Button.default(Text("Ok")))
                })
        }
    }
}

struct WaitingRoomView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoomView(member: .constant(.placeholder))
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
