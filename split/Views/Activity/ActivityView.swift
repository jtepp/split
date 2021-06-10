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
    @Binding var m: Member
    @State var showSplash = false
    var body: some View {
        ScrollView {
            HStack {
                HeaderText(text: "Activity")
                Spacer()
                Button(action: {
                    showSplash = true
                }, label:{
                    Image(systemName: "questionmark")
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
            }
            if house.payments.isEmpty {
                VStack {
                    Spacer()
                    Text("No payments have been made or requested yet")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white.opacity(0.2))
                        )
                        .onTapGesture {
                            tabSelection = 2
                        }
                        .padding()
                    
                }
            }
            ForEach(house.payments.sorted(by: { a, b in
                return a.time > b.time
            })) { payment in
                if house.members.contains(where: { (m) -> Bool in
                    return m.id == UserDefaults.standard.string(forKey: "myId")
                }){
                    if payment.isAn {
                        if house.members.first(where: { (m) -> Bool in
                            return m.id == UserDefaults.standard.string(forKey: "myId")
                        })!.admin {
                            ActivityAnnouncementCell(payment: .constant(payment))
                                .contextMenu(menuItems: {
                                    Button(action: {
                                        Fetch().deletePayment(p: payment, h: house)
                                    }, label: {
                                        Text("Delete")
                                            .foregroundColor(.red)
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.red)
                                        
                                    }
                                    )
                                })
                                .padding(.bottom, -20)
                        } else {
                            ActivityAnnouncementCell(payment: .constant(payment))
                                .padding(.bottom, -20)
                        }
                    } else if payment.isRequest {
                        
                        if payment.reqfrom.contains(house.members.first(where: { (m) -> Bool in
                            return m.id == UserDefaults.standard.string(forKey: "myId")
                        })!.name) {
                            ActivityRequestCell(payment: .constant(payment))
                                .contextMenu(menuItems: {
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
                                    if house.members.first(where: { (m) -> Bool in
                                        return m.id == UserDefaults.standard.string(forKey: "myId")
                                    })!.admin {
                                        Button(action: {
                                            Fetch().deletePayment(p: payment, h: house)
                                        }, label: {
                                            Text("Delete")
                                                .foregroundColor(.red)
                                            Image(systemName: "trash.fill")
                                                .foregroundColor(.red)
                                            
                                        }
                                        )
                                    }
                                })
                                .padding(.bottom, -20)
                        } else if payment.by == UserDefaults.standard.string(forKey: "myId") || house.members.first(where: { (m) -> Bool in
                            return m.id == UserDefaults.standard.string(forKey: "myId")
                        })!.admin {
                            ActivityRequestCell(payment: .constant(payment))
                                .contextMenu(menuItems: {
                                    Button(action: {
                                        Fetch().deletePayment(p: payment, h: house)
                                    }, label: {
                                        Text("Delete")
                                            .foregroundColor(.red)
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.red)
                                        
                                    }
                                    )
                                })
                            } else {
                            ActivityRequestCell(payment: .constant(payment))
                                .padding(.bottom, -20)
                        }
                    } else {
                        
                        if payment.by == UserDefaults.standard.string(forKey: "myId") || house.members.first(where: { (m) -> Bool in
                            return m.id == UserDefaults.standard.string(forKey: "myId")
                        })!.admin {
                            
                            ActivityPaymentCell(payment: .constant(payment))
                                .contextMenu(menuItems: {
                                    Button(action: {
                                        Fetch().deletePayment(p: payment, h: house)
                                    }, label: {
                                        Text("Delete")
                                        Image(systemName: "trash.fill")
                                    }
                                    )
                                })
                                .padding(.bottom, -20)
                            
                        } else {
                            ActivityPaymentCell(payment: .constant(payment))
                                .padding(.bottom, -20)
                            
                        }
                    }
                } else {
                    wrStuff(inWR: $inWR, h: $house, m: $m)
                }
            }
            
            .padding()
            Rectangle()
                .fill(Color.black)
                .frame(minHeight:120)
            
        }
        .foregroundColor(.white)
        .onAppear {
            //show splash for update
            if UserDefaults.standard.bool(forKey: "1.2") == false {
                showSplash = true
                UserDefaults.standard.setValue(true, forKey: "1.2")
            }
        }
        .sheet(isPresented: $showSplash, content: {
            SplashView(dontSplash: .constant(true), showSplash: $showSplash)
                .preferredColorScheme(.dark)
        })
    }
}


func wrStuff(inWR: Binding<Bool>, h: Binding<House>, m: Binding<Member>) -> EmptyView {
    m.wrappedValue = .empty
    UserDefaults.standard.set("", forKey: "houseId")
    UserDefaults.standard.set("", forKey: "myId")
    var q = House.empty
    q.members = [m.wrappedValue]
    h.wrappedValue = q
    inWR.wrappedValue = true
    print("DONE\n\n\n\n\(h.wrappedValue)\n\n")
    return EmptyView()
}
