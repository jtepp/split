//
//  TabBar.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct TabBar: View {
    @Binding var tabSelection: Int
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color("AccentGray"))
                    .frame(width: UIScreen.main.bounds.width, height: 25, alignment: .bottom)
            }
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(Color("AccentGray"))
                    .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .bottom)
                    .overlay(
                        HStack(spacing: 36) {
                            Image(systemName: "rectangle.grid.1x2")
                            Image(systemName: "person.2")
                            Image(systemName: "dollarsign.square")
                            Image(systemName: "person.crop.square")
                        }
                        .scaleEffect(1.6)
                        .foregroundColor(.white)
                        .overlay(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 10)
                                .offset(x: -139 + 99 * CGFloat(tabSelection), y:30)
                        )
                    )
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            TabBar(tabSelection: .constant(0))
        }
    }
}
