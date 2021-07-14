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
    var percent: CGFloat = 0.75
    @Binding var showStory: Bool
    @Binding var storyImage: String
    var body: some View {
        Button{}
            label: {
            b64toimg(b64: m.image)
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
                        .trim(from: 0, to: percent)
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

struct storyPreview: View {
    @State var showStory = false
    @State var storyImage = ""
    var body: some View {

        ScrollView(.vertical){
            ScrollView(.horizontal){
                HStack {
                    ForEach(0..<6) { _ in
                        StoryButton(percent: 0.90, showStory: $showStory, storyImage: $storyImage)
                    }
                    .padding()
                }
            }
            Spacer()
            Image(systemName: "person.3.sequence")
                .foregroundColor(.white)
        }
        .padding()
    }
}

struct StoryButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            storyPreview()
        }
        .preferredColorScheme(.light)
    }
}
