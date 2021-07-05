//
//  Image+prep.swift
//  spllitWidgetExtension
//
//  Created by Jacob Tepperman on 2021-07-05.
//

import SwiftUI

extension Image {
    func prep() -> some View {
        return self.resizable().aspectRatio(contentMode: .fit).minimumScaleFactor(0.1)
    }
}
