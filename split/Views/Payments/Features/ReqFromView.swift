//
//  ReqFromView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-12-13.
//

import SwiftUI

struct ReqFromView: View {
    var reqfrom: [String]
    var id: String
    var mems: [Member]
    let rfmax = 1
    @State var expanded = false
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<reqfrom.count) { i in
                    RFMemberView(name: reqfrom[i], member: mems.first(where: { m in
                        m.name == reqfrom[i]
                    }) ?? .empty, expanded: reqfrom.count > rfmax ? $expanded : .constant(true), index: i)
                }
                if !expanded && reqfrom.count > rfmax {
                    Text("\(reqfrom.first!) + \(reqfrom.count - 1)")
                        .foregroundColor(.white)
                        .padding(.leading, 18)
                }
            }
        }
        .onTapGesture {
            withAnimation(.easeOut) {
                if reqfrom.count > rfmax {
                    expanded.toggle()
                }
            }
        }
    }
}

struct ReqFromView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityRequestCell(payment: .constant(.placeholderr), hId: "placeholder", mems: [Member(id: "a", home: "", name: "Devon", image: "", admin: true)])
        }
    }
}

struct RFMemberView: View {
    var name: String
    var member: Member
    @Binding var expanded: Bool
    var index: Int
    var body: some View {
        HStack {
            b64toimg(b64: member.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 25, height: 25)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(color: Color.black.opacity(expanded ? 0 : 0.4), radius: 5, x: -10, y: 0)
//                .overlay(
//                    Image(systemName: "crown.fill")
//                        .offset(x: -3, y: -20)
//                        .scaleEffect(0.6)
//                        .rotationEffect(.degrees(-30))
//                        .foregroundColor(Color.white.opacity(member.admin ? 1 : 0))
//                )
                .padding(.trailing, expanded ? 0 : -18)
                .scaleEffect(expanded ? 1 : (1 + CGFloat(index)*0.03))
            if expanded {
                Text(name)
                    .foregroundColor(.white)
            }
        }
    }
}
