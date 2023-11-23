//
//  HeaderText.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct ActivityRequestCellContextMenuItems: View {
    @Binding var payment: Payment
    @Binding var house: House
    @Binding var m: Member
    @Binding var paymentEditing: Payment
    @Binding var showEdit: Bool
    
    var body: some View {
        if payment.to == m.name || m.admin {
            Button {
                paymentEditing = payment
                showEdit = true
            } label: {
                Text("Edit")
                Image(systemName: "square.and.pencil")
            }
        }
        
        if payment.reqfrom.contains(house.members.first(where: { (mm) -> Bool in
            return mm.id == m.id
        })?.name ?? "") {
            Button(action: {
                Fetch.sendPayment(p: Payment(to: payment.to, from: house.members.first(where: { (m) -> Bool in
                    return m.id == UserDefaults.standard.string(forKey: "myId")
                })!.name, amount: payment.amount / Float(payment.reqfrom.count), time: Int(NSDate().timeIntervalSince1970), type: .payment, by: UserDefaults.standard.string(forKey: "myId")!), h: house)
                print("quickpay")
            }, label: {
                Text("Pay")
                    .foregroundColor(.red)
                Image(systemName: "arrow.right.circle")
                    .foregroundColor(.red)
                
            }
            )
        }
        
        if payment.to != m.name /*payment.by != m.id*/ {
            if !payment.reqfrom.contains(m.name) {
                //opt in
                Button {
                    Fetch.optRequest(true, payment: payment, name: m.name)
                } label: {
                    Text("Opt in")
                    Image(systemName: "person.crop.circle.badge.plus")
                }
                
                
            } else if payment.reqfrom.count > 1 {
                //opt out
                Button {
                    Fetch.optRequest(false, payment: payment, name: m.name)
                } label: {
                    Text("Opt out")
                    Image(systemName: "person.crop.circle.badge.xmark")
                }
            }
            
        }
        
        if m.admin || payment.by == m.id {
            Button(action: {
                Fetch.deletePayment(p: payment, h: house)
            }, label: {
                Text("Delete")
                    .foregroundColor(.red)
                Image(systemName: "trash")
                    .foregroundColor(.red)
                
            }
            )
        }
        if payment.special == "includeself" {
            Text("Total: " + paymentPlusSelfTotal(payment))
        }
    }
}
