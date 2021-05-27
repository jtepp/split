//
//  ActivityView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct ActivityView: View {
    @Binding var house: House
    var body: some View {
        ScrollView {
            HeaderText(text: "Activity")
            ForEach(house.payments.sorted(by: { a, b in
                return a.time > b.time
            })) { payment in
                if payment.isRequest {
                    
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
