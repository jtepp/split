//
//  ReactionsView.swift
//  split
//
//  Created by Jacob Tepperman on 2022-03-07.
//

import SwiftUI

struct ReactionsView: View {
    @Binding var payment: Payment
    var reactionOptionsPresentTense = ["like", "dislike", "question"]
    var reactionOptions = ["liked", "disliked", "questioned"]
    var mems: [Member]
    var body: some View {
        Menu {
            ForEach(reactionOptionsPresentTense, id: \.self) { reactionOption in
                ReactionQuickAction(title: reactionOption, payment: $payment, reactions: $payment.editLog, selected: .constant(yourReaction(reactions: payment.editLog.filter({ (key: String, _: String) in
                    return !key.isNumeric
                }), memberID: (UserDefaults.standard.string(forKey: "myId") ?? "")).contains(reactionOption))) //NOTE: checking if past tense contains present tense, not if reaction is equal to selected
            }
            if !payment.editLog.filter({ (key: String, _: String) in
                return !key.isNumeric
            }).isEmpty {
                Text(payment.editLog.filter({ (key: String, _: String) in
                    return !key.isNumeric
                }).map({ key, value in
                    nameFromMemberID(key, members: mems) + " " + value
                }).joined(separator: ", "))
            }
        }
    label: {
        HStack(spacing:0) {
            //            ReactionsCompactLabel(title: "1", systemName: "heart.fill")
            HStack(spacing: 0) {
                if yourReaction(reactions: payment.editLog.filter({ (key: String, _: String) in
                    return !key.isNumeric
                }), memberID: (UserDefaults.standard.string(forKey: "myId") ?? "")) == "none" {
                    Text("+")
                    if payment.editLog.contains(where: { (key: String, _: String) in
                        return !key.isNumeric
                    }) {
                        Text("|")
                            .padding(.leading, 2)
                    }
                }
            }
            .padding(.top, -2)
            ForEach(reactionOptions, id: \.self) { reactionOption in
                if countReaction(reactionOption, reactions: payment.editLog.filter({ (key: String, _: String) in
                    return !key.isNumeric
                })) > 0 {
                    ReactionsCompactLabel(title: String(countReaction(reactionOption, reactions: payment.editLog.filter({ (key: String, _: String) in
                        return !key.isNumeric
                    }))), systemName: reactionToImageName(reactionOption), selected: .constant(yourReaction(reactions: payment.editLog.filter({ (key: String, _: String) in
                        return !key.isNumeric
                    }), memberID: (UserDefaults.standard.string(forKey: "myId") ?? "")) == reactionOption))
                        .scaleEffect(0.7)
                }
            }
        }
        .font(.caption)
        .foregroundColor(.white)
        .padding(.horizontal, 2)
        .background(
            Capsule()
                .fill(Color("DarkMaterial"))
        )
        .padding(2)
    }
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
    return reactions.reduce(0) { $0 + ($1.value == reactionName ? 1 : 0)}
}

func yourReaction(reactions: [String: String], memberID: String) -> String {
    return reactions.first { (key: String, _: String) in
        key == memberID
    }?.value ?? "none"
}

func reactionToImageName(_ reaction: String) -> String {
    switch(reaction) {
    case "liked": fallthrough
    case "like": return "heart.fill"
    case "disliked": fallthrough
    case "dislike": return "hand.thumbsdown.fill"
    case "questioned": fallthrough
    case "question": return "questionmark"
    default: return ""
    }
}

func nameFromMemberID(_ id: String, members: [Member]) -> String {
    return (members.first { m in
        m.id == id
    } ?? .empty).name
}

func presentToPastReaction(_ present: String) -> String {
    switch(present) {
    case "like": return "liked"
    case "dislike": return "disliked"
    case "question": return "questioned"
    default: return ""
    }

}
