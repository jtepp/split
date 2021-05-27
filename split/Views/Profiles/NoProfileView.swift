//
//  NoProfileView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-27.
//

import SwiftUI

struct NoProfileView: View {
    @Binding var show: Bool
    @State var newMember = Member.empty
    var body: some View {
        EditProfileView(m: $newMember)
    }
}
