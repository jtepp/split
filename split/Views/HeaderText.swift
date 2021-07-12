//
//  HeaderText.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct HeaderText: View {
    let text: String
    var space: Bool = true
    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
            if space {Spacer()}
        }
        .padding(space ? .horizontal : .leading)
        .padding(.vertical)
    }
}
