//
//  StoryView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-15.
//

import SwiftUI

struct StoryView: View {
    @Binding var storyImage: String
    var body: some View {
        b64toimg(b64: storyImage, story: true)
    }
}

struct StoryView_Previews: PreviewProvider {
    static var previews: some View {
        storyPreview()
    }
}
