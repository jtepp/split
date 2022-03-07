//
//  ReactionQuickAction.swift
//  split
//
//  Created by Jacob Tepperman on 2022-03-07.
//

import SwiftUI

struct ReactionQuickAction: View {
    var title: String
    @Binding var reactions: [String: String]
    @Binding var selected: Bool
    var body: some View {
        Button {
            // set editlog[id] = pastTense or set editlog[id] = none
        } label: {
            if selected {
                    Text("Remove " + title)
            } else {
                Text(title.prefix(1).uppercased() + title.suffix(title.count-1))
            }
            Image(systemName: reactionToImageName(title))
        }
    }
}
