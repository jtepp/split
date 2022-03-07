//
//  ReactionsView.swift
//  split
//
//  Created by Jacob Tepperman on 2022-03-07.
//

import SwiftUI

struct ReactionsView: View {
    @State var payment: Payment = .placeholder
    var body: some View {
        HStack(spacing:0) {
//            ReactionsCompactLabel(title: "1", systemName: "heart.fill")
            Text("+")
            Text("|")
                .padding(.leading, 2)
            ReactionsCompactLabel(title: "1", systemName: "heart.fill")
                .scaleEffect(0.75)
                .padding(.top, 2)
        }
        .font(.caption2)
        .foregroundColor(.white)
        .padding(.horizontal, 2)
        .padding(.top, -2)
        .background(
            Capsule()
                .fill(Color("DarkMaterial"))
        )
        .padding(2)
    }
}

struct ReactionsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ScrollView {
                ForEach(Range(0...4)) { _ in
                    ActivityPaymentCell(payment: .constant(.placeholder), mems: [Member]())
                }
            }
        }
    }
}


func countReaction(_ reactionName: String, reactions: [String: String]) -> Int {
    return reactions.reduce(0) { $0 + ($1.key == reactionName ? 1 : 0)}
}
