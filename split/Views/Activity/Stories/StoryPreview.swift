//
//  StoryPreview.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-15.
//

import SwiftUI

struct StoryPreview: View {
    @State var showStory = false
    @State var storyImage = ""
    @State var internalOffset: CGFloat = 0
    @State var dismissScale: CGFloat = 1
    var body: some View {

        ZStack {
            ScrollView(.vertical){
                ScrollView(.horizontal){
                    HStack {
                        ForEach(0..<6) { _ in
                            StoryButton(percent: 0.90, showStory: $showStory, storyImage: $storyImage, internalOffset: $internalOffset)
                        }
                        .padding()
                    }
                }
                Spacer()
            }
            .padding()
            .blur(radius: showStory ? 10 : 0)
            .allowsHitTesting(!showStory)
            
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Text("Swipe to dismiss")
                            .font(.headline)
                            .bold()
                            .padding(4)
                        Image(systemName: "chevron.compact.down")
                        Image(systemName: "chevron.compact.down")
                            .opacity(0.4)
                        Image(systemName: "chevron.compact.down")
                            .opacity(0.1)
                    }
                    .foregroundColor(.white)
                    .scaleEffect(dismissScale)
                    Spacer()
                }
                    .frame(height:100)
                StoryView(showStory: $showStory, storyImage: $storyImage, offset: $internalOffset, dismissScale: $dismissScale)
            }
            .allowsHitTesting(showStory)
            .offset(y: showStory ? 0 : UIScreen.main.bounds.height)

        }
    }
}

struct StoryPreview_Previews: PreviewProvider {
    static var previews: some View {
        StoryPreview()
            .background(Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}
