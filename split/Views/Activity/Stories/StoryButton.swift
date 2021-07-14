//
//  StoryButton.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-13.
//

import SwiftUI

struct StoryButton: View {
    let gradient = AngularGradient(
        gradient: Gradient(colors: [Color.red, .orange, .orange, .yellow, .yellow, .green, .green, .purple, .purple, .red]),
        center: .center)
    @State var m: Member = .placeholder2
    let percent: CGFloat = 0.75
    var body: some View {
        ZStack {
//            b64toimg(b64: m.image)
            Image("Face")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(radius: 4)
                .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color("Material"))
                )
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .trim(from: 0.0, to: percent)
                        .stroke(gradient, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                )
                .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("Material").opacity(0.2))
                )
                .padding(.bottom, 22)
                .overlay(
                    Text(m.name)
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.white)
                        .minimumScaleFactor(0.8)
                        .padding(4)
                        .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("Material").opacity(0.2))
                        )
                        .frame(maxWidth: 84, maxHeight: 20)
                        .fixedSize(horizontal: true, vertical: false)
                    ,
                    alignment: .bottom
                )
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

        }
    }
}

struct StoryButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            StoryButton()
        }
        .preferredColorScheme(.light)
    }
}
