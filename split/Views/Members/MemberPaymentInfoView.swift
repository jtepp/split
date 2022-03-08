//
//  MemberPaymentInfoView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct MemberPaymentInfoView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var member: Member
    @Binding var house: House
    @State var settleMembers = [Member]()
    
    var body: some View {
        VStack {
            HStack {
                Text("Balances")
                    .font(.headline)
                Spacer()
            }
            Rectangle()
                .fill(Color.black.opacity(colorScheme == .dark ? 1 : 0.5))
                .frame(height:2)
            
            ScrollView {
                if (member.owesMe.values.reduce(0, {a, b in
                    a + b
                }) - member.iOwe.values.reduce(0, {a, b in
                    a + b
                }) != 0) {
                    
                    ForEach(settlePayments(settleMembers).filter({ p in
                        p.to == member.name || p.from == member.name
                    })) { p in
                        HStack {
                        if checkWithMy(id: member.id) {
                            if p.to == member.name {
                                Text("\(p.from) owes you:")
                            } else {
                                Text("You owe \(p.to):")
                            }
                        } else {
                                Text("\(p.from) owes \(p.to):")
                        }
                            Spacer()
                            
                            Text("\(String(format: "$%.2f", p.amount))")
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                       
                            
                    }
                    
                    
                    
                    
//                    ForEach(house.members.filter({ (m) -> Bool in
//                        return ((member.iOwe[m.name] ?? 0) - (member.owesMe[m.name] ?? 0)) != 0
//                    })) { m in
//                        HStack {
//                            //if member is myId
//                            if checkWithMy(id: member.id) {
//                                Text((member.iOwe[m.name] ?? 0) - (member.owesMe[m.name] ?? 0) > 0 ? "You owe \(m.name):" : "\(m.name) owes you:")
//                            }
//                            else {
//                                //if member is not myId but m is myId
//                                if checkWithMy(id: m.id) {
//                                    Text((member.iOwe[m.name] ?? 0) - (member.owesMe[m.name] ?? 0) > 0 ? "\(member.name) owes you:" : "You owe \(member.name):")
//                                }
//                                else {
//                                    //if member is not myId^ and m is not myId
//                                    Text((member.iOwe[m.name] ?? 0) - (member.owesMe[m.name] ?? 0) > 0 ? "\(member.name) owes \(m.name):" : "\(m.name) owes \(member.name):")
//                                }
//                                //
//                                //
//                            }
//                            Spacer()
//                            Text("$\(abs((member.iOwe[m.name] ?? 0) - (member.owesMe[m.name] ?? 0)), specifier: "%.2f")")
//                        }
//                        .padding(.horizontal)
//                        .padding(.top, 10)
//                    }
                }
            }
            .frame(maxHeight: 160)
            .padding(.bottom, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        Color.black.opacity(colorScheme == .dark ? 1 : 0.5)
                    )
            )
            
        }
        
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    Color("DarkMaterial")
                )
        )
        .padding()
        .onAppear {
            Fetch.returnMembers(hId: $house.wrappedValue.id, nm: $settleMembers)
        }
    }
}
func checkWithMy(id: String) -> Bool {
    return id == UserDefaults.standard.string(forKey: "myId")
}
