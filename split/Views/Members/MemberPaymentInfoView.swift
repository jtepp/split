//
//  MemberPaymentInfoView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct MemberPaymentInfoView: View {
    @Binding var member: Member
    @Binding var house: House
    var body: some View {
        VStack {
            HStack {
                Text("Balances")
                    .font(.headline)
                Spacer()
            }
            Rectangle()
                .fill(Color.black.opacity(0.5))
                .frame(height:2)
            
            ScrollView {
                ForEach(house.members.filter({ (m) -> Bool in
                    return ((member.iOwe[m.name] ?? 0) - (member.owesMe[m.name] ?? 0)) != 0
                })) { m in
                    HStack {
                        //if member is myId
                        if checkWithMy(id: member.id) {
                            Text((member.iOwe[m.name] ?? 0) - (member.owesMe[m.name] ?? 0) > 0 ? "You owe \(m.name):" : "\(m.name) owes you:")
                        }
                        else {
                            //if member is not myId but m is myId
                            if checkWithMy(id: m.id) {
                                Text((member.iOwe[m.name] ?? 0) - (member.owesMe[m.name] ?? 0) > 0 ? "\(member.name) owes you:" : "You owe \(member.name):")
                            }
                            else {
                                //if member is not myId^ and m is not myId
                                Text((member.iOwe[m.name] ?? 0) - (member.owesMe[m.name] ?? 0) > 0 ? "\(member.name) owes \(m.name):" : "\(m.name) owes \(member.name):")
                            }
//                            
//
                        }
                        Spacer()
                        Text("$\(abs((member.iOwe[m.name] ?? 0) - (member.owesMe[m.name] ?? 0)), specifier: "%.2f")")
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                
            }
            .frame(maxHeight: 160)
            .padding(.bottom, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        Color.black.opacity(0.5)
                    )
            )
        }
        
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    Color.white.opacity(0.2)
                )
        )
        .padding()
    }
}
func checkWithMy(id: String) -> Bool {
    return id == UserDefaults.standard.string(forKey: "myId")
}
