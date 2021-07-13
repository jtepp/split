//
//  ActivityView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

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
    var body: some View {
        ScrollView {
            HStack {
                HeaderText(text: "Activity", space: false, clear: $TrayButtonOpen)
                TrayButton(open: $TrayButtonOpen, incPay: $incPay, incReq: $incReq, incAn: $incAn, incGM: $incGM)
                Spacer()
            }
            .frame(height:46)
            .overlay(
                Button(action: {
                    showSplash = true
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
            if house.payments.isEmpty || !house.payments.contains { pp in
                return !pp.isAn
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
                return incPay ? true :(p.isAn || p.isRequest || p.isGM)
            })
            .filter({p in
                return incReq ? true : !p.isRequest
            })
            .filter({p in
                return incAn ? true : !p.isAn
            })
            .filter({p in
                return incGM ? true : !p.isGM
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
            ForEach(house.payments.sorted(by: { a, b in
                return a.time > b.time
            }).filter({p in
                return incPay ? true :(p.isAn || p.isRequest || p.isGM)
            })
            .filter({p in
                return incReq ? true : !p.isRequest
            })
            .filter({p in
                return incAn ? true : !p.isAn
            })
            .filter({p in
                return incGM ? true : !p.isGM
            })
            ) { payment in
                if house.members.contains(where: { (m) -> Bool in
                    return m.id == UserDefaults.standard.string(forKey: "myId")
                }){
                    if payment.isAn {
                            ActivityAnnouncementCell(payment: .constant(payment))
                                .contextMenu(menuItems: {
                                    if m.admin {
                                    Button(action: {
                                        Fetch().deletePayment(p: payment, h: house)
                                    }, label: {
                                        Text("Delete")
//                                            .foregroundColor(.red)
                                        Image(systemName: "trash")
//                                            .foregroundColor(.red)
                                        
                                    }
                                    )
                                    }
                                })
                    } else if payment.isGM {
                        ActivityMessageCell(allPayments: .constant(house.payments.sorted(by: { a, b in
                            return a.time > b.time
                        })), payment: .constant(payment), member: $m, GMmsg: $GMmsg, showMessagePopover: $showMessagePopover)
                            
                    } else if payment.isRequest {
                        
                        ActivityRequestCell(payment: .constant(payment))
                            .contextMenu(menuItems: {
                                if payment.reqfrom.contains(house.members.first(where: { (mm) -> Bool in
                                    return mm.id == m.id
                                })?.name ?? "") {
                                    Button(action: {
                                        Fetch().sendPayment(p: Payment(to: payment.to, from: house.members.first(where: { (m) -> Bool in
                                            return m.id == UserDefaults.standard.string(forKey: "myId")
                                        })!.name, amount: payment.amount / Float(payment.reqfrom.count), time: Int(NSDate().timeIntervalSince1970), isRequest: false, isAn: false, by: UserDefaults.standard.string(forKey: "myId")!), h: house)
                                        print("quickpay")
                                    }, label: {
                                        Text("Pay")
                                            .foregroundColor(.red)
                                        Image(systemName: "arrow.right.circle")
                                            .foregroundColor(.red)
                                        
                                    }
                                    )
                                }
                                if m.admin || payment.by == m.id {
                                    Button(action: {
                                        Fetch().deletePayment(p: payment, h: house)
                                    }, label: {
                                        Text("Delete")
                                            .foregroundColor(.red)
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                        
                                    }
                                    )
                                }
                            })
                    } else {
                        
                        
                            
                            ActivityPaymentCell(payment: .constant(payment))
                                .contextMenu(menuItems: {
                                    if payment.by == m.id || m.admin {
                                    Button(action: {
                                        Fetch().deletePayment(p: payment, h: house)
                                    }, label: {
                                        Text("Delete")
                                        Image(systemName: "trash")
                                    }
                                    )
                                    }
                                })
                                
                    }
                } else {
                    Fetch().checkThere(m: $m, h:$house){ has in
                        if has {
                            getHouse(h: $house, m: $m, inWR: $inWR, noProf: $noProf)
                        } else {
                            if UserDefaults.standard.string(forKey: "houseId") != "waitingRoom" {
                                wrStuff(inWR: $inWR, h: $house, m: $m)
                            }
                        }
                    }
                }
            }
            
            .padding()
            .padding(.bottom, -20)
            Rectangle()
                .fill(Color.black)
                .frame(minHeight:120)
                .padding(.top, 20)
            
        }
        .foregroundColor(.white)
        
        .onAppear {
            //show splash for update
            if UserDefaults.standard.bool(forKey: "2.3.0") == false {
                showSplash = true
                UserDefaults.standard.setValue(true, forKey: "2.3.0")
            }
        }
        .sheet(isPresented: $showSplash, content: {
            SplashView(dontSplash: .constant(true), showSplash: $showSplash)
                .background(
                    Color.black.edgesIgnoringSafeArea(.all)
                )
                .animation(Animation.easeIn.speed(3))
        })
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

func getHouse(h: Binding<House>, m: Binding<Member>, inWR: Binding<Bool>, noProf: Binding<Bool>) {//-> EmptyView {
    Fetch().getHouse(h: h, m: m, inWR: inWR, noProf: noProf)
    print("gotgot\(h.wrappedValue.id)\(m.wrappedValue.home)")
//    return EmptyView()
}
