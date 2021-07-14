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
    let dull = AngularGradient(
        gradient: Gradient(colors: [Color.gray]),
        center: .center)
    let viewed = false
    @State var m: Member = .placeholder2
    let percent: CGFloat = 0.75
    let storyImage: String = b64ss
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
                        .stroke(viewed ? dull : gradient, style: StrokeStyle(lineWidth: 6, lineCap: .round))
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
