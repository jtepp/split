//
//  HeaderText.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct HeaderText: View {
    let text: String
    var body: some view {
        HStack {
                            Text(text)
                                .foregroundColor(.white)
                                .font(.largeTitle)
                                .bold()
                            Spacer()
                        }
                        .padding()
    }
}
