//
//  HeaderText.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct ActivityContentView: View {
    @Binding var house: House
    @Binding var inWR: Bool
    @Binding var noProf: Bool
    @Binding var incPay: Bool
    @Binding var incReq: Bool
    @Binding var incAn: Bool
    @Binding var incGM: Bool
    @Binding var searchText: String
    @Binding var m: Member
    @Binding var GMmsg: String
    @Binding var showMessagePopover: Bool
    @Binding var paymentEditing: Payment
    @Binding var showEdit: Bool
    
    var body: some View {
        ForEach(house.payments.sorted(by: { a, b in
            return a.time > b.time
        }).filter({p in
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
                        return searchText == "" ? true : p.toString().contains(searchText)
                    })
        ) { payment in
//            Text(payment.to)
            if house.members.contains(where: { (m) -> Bool in
                return m.id == UserDefaults.standard.string(forKey: "myId")
            }){
                if payment.type == .announcement {
                    ActivityAnnouncementCell(payment: .constant(payment))
                        .contextMenu(menuItems: {
                            if m.admin {
                                Button(action: {
                                    Fetch.deletePayment(p: payment, h: house)
                                }, label: {
                                    Text("Delete")
                                    //                                            .foregroundColor(.red)
                                    Image(systemName: "trash")
                                    //                                            .foregroundColor(.red)
                                    
                                }
                                )
                            }
                        })
                }
                    else if payment.type == .groupmessage {
                    ActivityMessageCell(allPayments: .constant(house.payments.sorted(by: { a, b in
                        return a.time > b.time
                    })), payment: .constant(payment), member: $m, GMmsg: $GMmsg, showMessagePopover: $showMessagePopover)
                    
                }
                else if payment.type == .request {

                    ActivityRequestCell(payment: .constant(payment), hId: house.id, mems: house.members)
                        .contextMenu(menuItems: {
                            ActivityRequestCellContextMenuItems(payment: .constant(payment), house: $house, m: $m, paymentEditing: $paymentEditing, showEdit: $showEdit)
                        })
                }
                else if payment.type == .payment {

                    
                    
                    ActivityPaymentCell(payment: .constant(payment), mems: house.members)
                        .contextMenu(menuItems: {
                            if payment.from == m.name || m.admin {
                                Button {
                                    paymentEditing = payment
                                    showEdit = true
                                } label: {
                                    Text("Edit")
                                    Image(systemName: "square.and.pencil")
                                }
                            }
                            if payment.by == m.id || m.admin {
                                Button(action: {
                                    Fetch.deletePayment(p: payment, h: house)
                                }, label: {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                                )
                            }
                        })
                    
                }
            } else {
                Fetch.checkThere(m: $m, h:$house){ has in
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
    }
}

func getHouse(h: Binding<House>, m: Binding<Member>, inWR: Binding<Bool>, noProf: Binding<Bool>) {//-> EmptyView {
    Fetch.getHouse(h: h, m: m, inWR: inWR, noProf: noProf)
    print("gotgot\(h.wrappedValue.id)\(m.wrappedValue.home)")
    //    return EmptyView()
}
