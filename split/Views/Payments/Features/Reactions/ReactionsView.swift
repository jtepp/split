//
//  ReactionsView.swift
//  split
//
//  Created by Jacob Tepperman on 2022-03-07.
//

import SwiftUI

struct ReactionsView: View {
    @Binding var payment: Payment
    var reactionOptionsPresentTense = ["like", "dislike", "appreciate", "emphasize", "question"]
    var reactionOptions = ["liked", "disliked", "appreciated", "emphasized", "questioned"]
    var mems: [Member]
    var body: some View {
        Menu {
            ForEach(reactionOptionsPresentTense, id: \.self) { reactionOption in
                ReactionQuickAction(title: reactionOption, payment: $payment, reactions: $payment.editLog, selected: .constant(yourReaction(reactions: payment.editLog.filter({ (key: String, _: String) in
                    return !key.isNumeric
                }), memberID: (UserDefaults.standard.string(forKey: "myId") ?? "ABCNOID")) == presentToPastReaction(reactionOption)), member: mems.first(where: { m in
                    m.id == (UserDefaults.standard.string(forKey: "myId") ?? "")
                }) ?? .empty)
            }
            if !payment.editLog.filter({ (key: String, value: String) in
                return !key.isNumeric && value.components(separatedBy: "|").last ?? "none" != "none"
            }).isEmpty {
                Text(payment.editLog.filter({ (key: String, value: String) in
                    return !key.isNumeric && value.components(separatedBy: "|").last ?? "none" != "none"
                }).map({ key, value in
                    nameFromMemberID(key, members: mems) + " " + (value.components(separatedBy: "|").last ?? "none")
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
                    if payment.editLog.contains(where: { (key: String, value: String) in
                        return !key.isNumeric && value.components(separatedBy: "|").last ?? "none" != "none"
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
//                        .scaleEffect(0.7)
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
    return reactions.reduce(0) { $0 + ($1.value.components(separatedBy: "|").last ?? "none" == reactionName ? 1 : 0)}
}

func reactionsMade(reactions: [String: String], pastTenseArray: [String]) -> [String] {
    var output = [String]()
    
    pastTenseArray.forEach { rx in
        if reactions.values.map({ val in
            return val.components(separatedBy: "|").last ?? "none"
        }).contains(rx) && !output.contains(rx) {
            output.append(rx)
        }
    }
    
    return output
}

func yourReaction(reactions: [String: String], memberID: String) -> String {
    return (reactions.first { (key: String, _: String) in
        key == memberID
    }?.value ?? "none").components(separatedBy: "|").last ?? "none"
}

func reactionToImageName(_ reaction: String) -> String {
    switch(reaction.components(separatedBy: "|").last ?? "none") {
    case "liked": fallthrough
    case "like": return "heart.fill"
    case "disliked": fallthrough
    case "dislike": return "hand.thumbsdown.fill"
    case "appreciated": fallthrough
    case "appreciate": return "hands.clap.fill"
    case "emphasized": fallthrough
    case "emphasize": return "exclamationmark.2"
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
    case "appreciate": return "appreciated"
    case "emphasize": return "emphasized"
    case "question": return "questioned"
    default: return ""
    }

}
