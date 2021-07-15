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
    var body: some View {
        ZStack {
            b64toimg(b64: storyImage, story: true)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .offset(y: offset)
                .gesture(DragGesture().onChanged({ value in
                    offset = value.translation.height
                }).onEnded({ _ in
                    if offset > 100 {
                        withAnimation {
                            showStory = false
                        }
                    } else {
                        withAnimation {
                            offset = 0
                        }
                    }
                }))
        }
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        storyPreview()
    }
}
