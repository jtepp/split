//
//  QuickSettleView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-09-25.
//

import SwiftUI

struct QuickSettleView: View {
    var h: House
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
        }
    }
}

struct QuickSettleView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView(house: .constant(House.placeholder), payType: .constant(0), tabSelection: .constant(0), pchoice: .constant([.empty]), rchoice: .constant([.empty]))
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
