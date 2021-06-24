//
//  AlternateIconButton.swift
//  split
//
//  Created by Jacob Tepperman on 2021-06-24.
//

import SwiftUI

struct AlternateIconButton: View {
    @Binding var choice: String
    var name: String
    var body: some View {
        Image(uiImage: UIImage(named: name) ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct AlternateIconButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
            AlternateIconButton(choice: .constant("Default-inverse"), name: "Default")
                .foregroundColor(.white)
                Spacer()
            }
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}
