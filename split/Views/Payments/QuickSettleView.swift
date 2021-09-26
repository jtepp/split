//
//  QuickSettleView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-09-25.
//

import SwiftUI

struct QuickSettleView: View {
    var h: Binding<House>
    @Binding var settleMembers: [Member]
    func upCount() -> Int {
        return Int(ceil(Float(settleMembers.count)/2))
    }
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            LazyVGrid(columns: [GridItem(), GridItem()], content: {
                ForEach(settleMembers.sorted(by: { a, b in
                    memberBalanceFloat(m: a) > memberBalanceFloat(m: b)
                })) {member in
                    MemberCellBalance(m: .constant(member))
                        .padding(.horizontal, 5)
                }
                
                .padding(.bottom, 5)
            })
            .padding(.horizontal)
        }
    }
}

struct QuickSettleView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView(house: .constant(House.placeholder), payType: .constant(0), tabSelection: .constant(0), pchoice: .constant([.empty]), rchoice: .constant([.empty]))
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
