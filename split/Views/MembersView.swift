//
//  MembersView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct MembersView: View {
    @Binding var members: [Member]
    var body: some View {
        ForEach(members) { member in
            MemberCell(m: .constant(member))
        }
    }
}

struct MembersView_Previews: PreviewProvider {
    static var previews: some View {
        MembersView(members: .constant([Member.placeholder]))
    }
}

