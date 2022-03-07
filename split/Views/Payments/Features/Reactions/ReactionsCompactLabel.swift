//
//  ReactionsCompactLabel.swift
//  split
//
//  Created by Jacob Tepperman on 2022-03-07.
//

import SwiftUI

struct ReactionsCompactLabel: View {
    var title: String
    var systemName: String
    var body: some View {
        HStack(spacing: 0) {
            Image(systemName: systemName)
            Text(title)
        }
    }
}
