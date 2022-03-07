//
//  ReactionQuickAction.swift
//  split
//
//  Created by Jacob Tepperman on 2022-03-07.
//

import SwiftUI

struct ReactionQuickAction: View {
    var title: String
    @Binding var payment: Payment
    @Binding var reactions: [String: String]
    @Binding var selected: Bool
    let member = Member(id: UserDefaults.standard.string(forKey: "myId") ?? "NOMYIDHERE", home: UserDefaults.standard.string(forKey: "hId") ?? "NOHOMEIDHERE", name: "", image: "")
    var body: some View {
        Button {
            // set editlog[id] = pastTense or set editlog[id] = none
            if selected {
                Fetch().updateReactions(payment: payment, member: member, reaction: "none")
            } else {
                Fetch().updateReactions(payment: payment, member: member, reaction: presentToPastReaction(title))
            }
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
