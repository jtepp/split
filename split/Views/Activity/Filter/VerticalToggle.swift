//
//  VerticalToggle.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-12.
//

import SwiftUI

struct VerticalToggle: View {
    @Binding var on: Bool
    var body: some View {
        Capsule()
            .fill(
                on ? Color.green : Color.gray
            )
            .overlay(
                VStack {
//                    Rectangle().fill(Color.clear)
                    Spacer()
                        .frame(maxHeight: on ? CGFloat(0) : .infinity)
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 4)
                        .padding(2)
//                    Rectangle().fill(Color.clear)
                    Spacer()
                        .frame(maxHeight: !on ? CGFloat(0) : .infinity)
                }
            )
    }
}

struct VerticalToggle_Previews: PreviewProvider {
    static var previews: some View {
        VerticalToggle(on: .constant(true))
    }
}
