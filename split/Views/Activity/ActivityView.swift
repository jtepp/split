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
    var body: some View {
        ScrollView {
            HeaderText(text: "Activity")
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
                    
                    if payment.by == UserDefaults.standard.string(forKey: "myId") || house.members.first(where: { (m) -> Bool in
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
                            .padding(.bottom, -20)
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
            }
            
            .padding()
            Spacer(minLength: 80)
        }
        .foregroundColor(.white)
    }
}
