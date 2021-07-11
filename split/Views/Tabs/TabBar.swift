//
//  TabBar.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct TabBar: View {
    @Binding var tabSelection: Int
    let halfLeft = -UIScreen.main.bounds.width/2
    @Binding var engaged: Bool
    @Binding var watch: Int
    var body: some View {
            VStack {
                Spacer()
                CustomRoundedRect(corners: [.topLeft,.topRight], radius: 25)
                    .fill(Color("AccentGray"))
                    .frame(width: UIScreen.main.bounds.width, height: 100, alignment: .bottom)
                    .shadow(color: .black, radius: 10)
                    .overlay(
                        HStack(spacing: 60) {
                            TabButton(tabSelection: $tabSelection, index: 0, name: "rectangle.grid.1x2", engaged: .constant(false), watch: .constant(0))
                            TabButton(tabSelection: $tabSelection, index: 1, name: "person.2", engaged: .constant(false), watch: .constant(0))
                            TabButton(tabSelection: $tabSelection, index: 2, name: "dollarsign.square", engaged: .constant(false), watch: .constant(0))
                            TabButton(tabSelection: $tabSelection, index: 3, name: "person.crop.square", engaged: $engaged, watch: $watch)
                        }
//                        .scaleEffect(1.6)
                        .foregroundColor(.white)
                        .overlay(
                            Circle()
                                .fill(Color.white)
                                .frame(width: 10)
                                .offset(x: -45 * 2 * (1.5 - CGFloat(tabSelection)), y:30)
                                .animation(Animation.easeOut.speed(1.4))
                                .shadow(color: .black, radius: 10)
                        )
                    )
            }
            .edgesIgnoringSafeArea(.all)
    }
}

//struct TabBar_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            Color.black
//                .edgesIgnoringSafeArea(.all)
//            TabBar(tabSelection: .constant(0))
//        }
//    }
//}

struct TabButton: View {
    @Binding var tabSelection: Int
    let index: Int
    let name: String
    @Binding var engaged: Bool
    @Binding var watch: Int
    var body: some View {
        Image(systemName: "\(name)\(tabSelection == index ? ".fill" : "")")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 30, height: 30)
            .onTapGesture {
                tabSelection = index
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                if index == 3 {
                    watch += 1
                    if tabSelection == 3 {
                        engaged.toggle()
                    } else {
                        engaged = false
                    }
                } else {
                    engaged = true
                }
            }
    }
}
