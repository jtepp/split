//
//  ReqFromView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-12-13.
//

import SwiftUI

struct ReqFromView: View {
    @Binding var reqfrom: [String]
    var id: String
    var mems: [Member]
    let rfmax = 1
    @State var expanded = false
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(reqfrom, id: \.self) { n in
                    RFMemberView(name: n, member: mems.first(where: { m in
                        m.name == n
                    }) ?? .empty, expanded: reqfrom.count > rfmax ? $expanded : .constant(true), index: reqfrom.firstIndex(of: n) ?? 0, maxIndex: reqfrom.count)
                }
                if !expanded && reqfrom.count > rfmax {
                    Text("\(reqfrom.last!) + \(reqfrom.count - 1)")
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
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
    var maxIndex: Int
    var body: some View {
        HStack {
            b64toimg(b64: member.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 25, height: 25)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(color: Color.black.opacity(expanded || index == 0 ? 0 : 0.4), radius: 5, x: -10, y: 0)
                .padding(.trailing, expanded ? 0 : -24)
                .scaleEffect(expanded ? 1 : scaleCalc(index, maxIndex))
            if expanded {
                Text(name)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
            }
        }
    }
}

struct SingleMemberPhotoView: View {
    var member: Member
    var body: some View {
        b64toimg(b64: member.image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 25, height: 25)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .shadow(radius: 6)
            .padding(.trailing, -5)
        Text(member.name)
            .font(.headline)
            .lineLimit(1)
            .minimumScaleFactor(0.1)
    }
}

func scaleCalc(_ index: Int, _ maxIndex: Int) -> CGFloat {
    let ci = CGFloat(index + 1)
    let cmi = CGFloat(maxIndex + 1)
    return 1 - (cmi - ci) * 0.05
}
