//
//  ReactionsCompactLabel.swift
//  split
//
//  Created by Jacob Tepperman on 2022-03-07.
//

import SwiftUI

struct ReactionsCompactLabel: View {
    var title: String
    var systemName: String
    @Binding var selected: Bool
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: systemName)
                .foregroundColor(selected ? reactionImageToColor(systemName) : .white)
                .scaleEffect(0.6)
            Text(title+" ")
                .font(.system(size: 8))
                .padding(.trailing, 2)

        }
    }
}


func reactionImageToColor(_ reaction: String) -> Color {
    switch(reaction) {
    case "heart.fill": return .red
    case "hand.thumbsdown.fill": return .blue
    case "questionmark": return .orange
    default: return .white
    }
}
