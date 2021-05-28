//
//  WaitingRoomView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-27.
//

import SwiftUI

struct WaitingRoomView: View {
    @Binding var member: Member
    @State var showJoin = false
    @State var hId = ""
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
                                .opacity(showJoin ? 0 : 1)
                            VStack {
                                InputField(name: "House ID", text: $hId)
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
                            .opacity(showJoin ? 1 : 0)
                            .allowsHitTesting(showJoin)
                        }
                        .animation(Animation.easeIn.speed(3))
                    )
            }
            Button(action: {
                showJoin.toggle()
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
            
            Button(action: {}, label: {
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
