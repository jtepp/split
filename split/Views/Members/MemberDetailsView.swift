//
//  MemberDetailsView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct MemberDetailsView: View {
    @Binding var member: Member
    var body: some View {
        Text(member.name)
    }
}
