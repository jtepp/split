//
//  FilterButton.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-12.
//

import SwiftUI

struct TrayButton: View {
    @Binding var open: Bool
    @Binding var incPay: Bool
    @Binding var incReq: Bool
    @Binding var incAn: Bool
    @Binding var incGM: Bool
    var body: some View {
        
        HStack {
            if open {
                HStack {
                    TrayItem(on: $incPay)
                    Rectangle()
                        .fill(Color("Material"))
                        .frame(width: 2)
                    TrayItem(on: $incReq, img: "arrow.left.circle")
                    Rectangle()
                        .fill(Color("Material"))
                        .frame(width: 2)
                    TrayItem(on: $incAn, img: "exclamationmark.square")
                    Rectangle()
                        .fill(Color("Material"))
                        .frame(width: 2)
                    TrayItem(on: $incGM, img: "text.bubble")
                }.padding(.horizontal)
            }
            Button {open.toggle()}
                label: {
                    ZStack {
                        Image("funnel")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 18, height: 18, alignment: .center)
                            .padding(14)
                            .opacity(open ? 0 : 1)
                            .allowsHitTesting(!open)
                        Image(systemName: "plus")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: 18, height: 18, alignment: .center)
                            .padding(14)
                            .rotationEffect(Angle(degrees: open ? 45 : -90))
                            .opacity(open ? 1 : 0)
                            .allowsHitTesting(open)
                        
                    }
                    
                }
        }
                .background(
                    Capsule()
                        .fill(
                            Color.gray.opacity(0.2)
                        )
                        .frame(height:46)
                )
                .frame(height:46)
                .animation(.easeOut)
        }
    }
    
    struct TBC: View {
        @State var open = false
        var body: some View {
            ScrollView {
                HStack {
                    HeaderText(text: "Activity", space: false, clear: .constant(false))
                        .opacity(open ? 0 : 1)
                    TrayButton(open: $open, incPay: .constant(true), incReq: .constant(true), incAn: .constant(true), incGM: .constant(true))
                    Spacer()
                }
                .frame(height:46)
                .overlay(
                    Button(action: {
                    }, label:{
                        Image(systemName: "questionmark")
                            .font(Font.body.bold())
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                Circle()
                                    .fill(
                                        Color.gray.opacity(0.2)
                                    )
                            )
                    })
                    .padding()
                    .offset(x: open ? 100 : 0)
                    .animation(.easeOut), alignment: .trailing
                )
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }
    }
    
    struct TrayButton_Previews: PreviewProvider {
        static var previews: some View {
            TBC()
        }
    }

