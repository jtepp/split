//
//  StoryButton.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-13.
//

import SwiftUI

struct StoryButton: View {
    let gradient = AngularGradient(
        gradient: Gradient(colors: [Color.blue, .white]),
        center: .center,
        startAngle: .degrees(270),
        endAngle: .degrees(0))
    let img = ""
    let percent = 0.75
    var body: some View {
        ZStack {
            b64toimg(b64: img)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(radius: 4)
//                .overlay(
//                    Image(systemName: "crown.fill")
//                        .offset(x: -3, y: -30)
//                        .scaleEffect(x: 1.2)
//                        .rotationEffect(.degrees(-30))
//                        .foregroundColor(Color.white.opacity(false ? 1 : 0))
//                )
            
            
//            Circle().stroke(Color.white, lineWidth: 46)
//
//            Circle()
//                .trim(from: 0, to: CGFloat(0.8))
//                .stroke(gradient, style: StrokeStyle(lineWidth: 46, lineCap: .round))
//                .overlay(
//                    Circle().trim(from: 0, to: CGFloat(0.8))
//                    .rotation(Angle.degrees(-4))
//                    .stroke(gradient, style: StrokeStyle(lineWidth: 46, lineCap: .butt))
//            )

        }.padding(60)
    }
}

struct StoryButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.blue.edgesIgnoringSafeArea(.all)
            StoryButton()
        }
    }
}
