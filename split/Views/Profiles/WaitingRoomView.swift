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
                                if showPanel == 1 {
                                    InputField(name: "House ID", text: $hId)
                                } else if showPanel == 2 {
                                    InputField(name: "House Name", text: $hNm)
                                }
                                InputField(name: "Password", text: $hPw)
                                Button(action: {
//                                    showJoin.toggle()
                                }, label: {
                                    HStack {
//                                        Spacer()
                                        Text("Join")
                                            .foregroundColor(.white)
//                                        Spacer()
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.blue)
                                    )
                                    .padding()
                                })
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
                hNm = ""
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
                hNm = ""
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
        }
    }
}

struct WaitingRoomView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoomView(member: .constant(.placeholder))
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
