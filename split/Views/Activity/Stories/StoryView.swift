//
//  StoryView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-15.
//

import SwiftUI

struct StoryView: View {
    @Binding var showStory: Bool
    @Binding var storyImage: String
    @Binding var offset:CGFloat
    @Binding var dismissScale: CGFloat
    var body: some View {
        ZStack {
            b64toimg(b64: storyImage, story: true)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .offset(y: offset)
                .gesture(DragGesture().onChanged({ value in
                    if abs(value.translation.height) < 100 {
                        offset = value.translation.height
                    }
                    if offset > 30 {
                        withAnimation(Animation.linear.speed(1.4)) {
                            dismissScale = 1.2
                        }
                    } else {
                        withAnimation(Animation.linear.speed(1.4)) {
                            dismissScale = 1
                        }
                    }
                }).onEnded({ _ in
                    if offset > 30 {
                        withAnimation {
                            showStory = false
                            dismissScale = 1
                        }
                    } else {
                        withAnimation(Animation.easeOut.speed(2)) {
                            offset = 0
                        }
                    }
                }))
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        StoryPreview()
            .background(Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}
