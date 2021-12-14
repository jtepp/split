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
    @State var mems = [Member]()
    var body: some View {
        ForEach(reqfrom, id: \.self) { n in
            RFMemberView(name: n, member: mems.first(where: { m in
                m.name == n
            }) ?? .empty)
        }
        .onAppear {
            Fetch().returnMembers(hId: id, nm: $mems, filter: reqfrom)
        }
    }
}

struct ReqFromView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            ActivityRequestCell(payment: .constant(.placeholderr), hId: "placeholder")
        }
    }
}

struct RFMemberView: View {
    var name: String
    var member: Member
    var body: some View {
        HStack {
            b64toimg(b64: member.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 20, height: 20)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 6)
                .overlay(
                    Image(systemName: "crown.fill")
                        .offset(x: -3, y: -15)
                        .scaleEffect(x:1.8)
                        .rotationEffect(.degrees(-30))
                        .foregroundColor(Color.white.opacity(member.admin ? 1 : 0))
            )
            Text(name)
                .foregroundColor(.white)
        }
    }
}
