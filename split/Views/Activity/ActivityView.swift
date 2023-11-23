//
//  ActivityView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI
import MbSwiftUIFirstResponder

struct ActivityView: View {
    @Binding var house: House
    @Binding var tabSelection: Int
    @Binding var inWR: Bool
    @Binding var noProf: Bool
    @Binding var m: Member
    @State var showSplash = false
    @Binding var showMessagePopover: Bool
    @Binding var GMmsg: String
    @State var incPay = true
    @State var incReq = true
    @State var incAn = true
    @State var incGM = true
    @State var TrayButtonOpen = false
    @ObservedObject var refresh: RefreshObject
    @State var lastScroll = -1
    @State var searchText = ""
    @State var showSearch = false
    @Binding var showEdit: Bool
    @State var paymentEditing = Payment.empty
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            ScrollView {
                ScrollViewReader { svr in
                    HStack {
                        HeaderText(text: "Activity", space: false, clear: $TrayButtonOpen)
                        TrayButton(open: $TrayButtonOpen, incPay: $incPay, incReq: $incReq, incAn: $incAn, incGM: $incGM, showSearch: $showSearch)
                        Spacer()
                    }
                    .frame(height:46)
                    .overlay(
                        Button(action: {
                            showSplash = true
                            //                                                Fetch.updatePayments3()
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
                        .offset(x: TrayButtonOpen ? 100 : 0)
                        .animation(.easeOut), alignment: .trailing
                    )
                    .padding(.top)
                    .id("top")
                    .onReceive(refresh.$activityScroll) { _ in
                        if refresh.activityScroll != lastScroll {
                            withAnimation() {
                                svr.scrollTo("top")
                            }
                            lastScroll = refresh.activityScroll
                        }
                    }
                    if showSearch {
                        HStack {
                            TextField("Search", text: $searchText)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .foregroundColor(.primary)
                                .padding(.leading)
                                .padding(.top, 10)
                                .onChange(of: searchText, perform: { _ in
                                    searchText = searchText.lowercased()
                                })
                                .opacity(colorScheme == .light ? 0.5 : 1)
                            Button("Cancel") {
                                searchText = ""
                                showSearch = false;
                            }
                            .foregroundColor(.blue)
                            .padding(.trailing)
                            .padding(.top, 8)
                        }
                    }
                    if house.payments.isEmpty || !house.payments.contains { pp in
                        return pp.type != .announcement
                    } {
                        VStack {
                            Spacer()
                            Text("No payments have been posted yet")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            Color("DarkMaterial")
                                        )
                                )
                                .onTapGesture {
                                    tabSelection = 2
                                }
                                .padding()
                            
                        }
                    } else if house.payments.filter({p in
                        return incPay ? true : p.type != .payment
                    })
                        .filter({p in
                            return incReq ? true : p.type != .request
                        })
                            .filter({p in
                                return incAn ? true : p.type != .announcement
                            })
                                .filter({p in
                                    return incGM ? true : p.type != .groupmessage
                                }).filter({ p in
                                    return searchText == "" ? true : p.toString().range(of: searchText.lowercased(), options: .caseInsensitive) != nil
                                }).isEmpty {
                        VStack {
                            Spacer()
                            Text("No payments visible through this filter")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            Color("DarkMaterial")
                                        )
                                )
                                .onTapGesture {
                                    tabSelection = 2
                                }
                                .padding()
                            
                        }
                    }
                    ActivityContentView(house: $house, inWR: $inWR, noProf: $noProf, incPay: $incPay, incReq: $incReq, incAn: $incAn, incGM: $incGM, searchText: $searchText, m: $m, GMmsg: $GMmsg, showMessagePopover: $showMessagePopover, paymentEditing: $paymentEditing, showEdit: $showEdit)
                    
                    .padding()
                    .padding(.bottom, -20)
                    Rectangle()
                        .fill(Color.black)
                        .frame(minHeight:120)
                        .padding(.top, 20)
                    
                }
            }
            .refreshable(action: {
                Fetch.getHouse(h: $house, m: $m, inWR: $inWR, noProf: $noProf)
            })
            .foregroundColor(.white)
            
            .onAppear {
                //show splash for update
                if UserDefaults.standard.bool(forKey: currentVersion) == false {
                    showSplash = true
                    UserDefaults.standard.setValue(true, forKey: currentVersion)
                }
            }
            .sheet(isPresented: $showSplash, content: {
                SplashView(dontSplash: .constant(true), showSplash: $showSplash)
                    .background(
                        Color.black.edgesIgnoringSafeArea(.all)
                    )
                    .animation(Animation.easeIn.speed(3))
            })
            if showEdit {
                Color.black.edgesIgnoringSafeArea(.all)
                ActivityEditView(house: $house, member: m, payment: paymentEditing, mems: $house.members, showEdit: $showEdit)
            }
        }
        
    }
}


func wrStuff(inWR: Binding<Bool>, h: Binding<House>, m: Binding<Member>) {//-> EmptyView {
    m.wrappedValue = .empty
    UserDefaults.standard.set("", forKey: "houseId")
    UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("", forKey: "houseId")
    UserDefaults.standard.set("", forKey: "myId")
    UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("", forKey: "myId")
    UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("", forKey: "myName")
    var q = House.empty
    q.members = [m.wrappedValue]
    h.wrappedValue = q
    inWR.wrappedValue = true
    print("DONEwrstuff\(h.wrappedValue.id)")
    //    return EmptyView()
}

