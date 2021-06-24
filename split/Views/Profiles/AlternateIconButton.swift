//
//  AlternateIconButton.swift
//  split
//
//  Created by Jacob Tepperman on 2021-06-24.
//

import SwiftUI

struct AlternateIconButton: View {
    @Binding var choice: String
    var name: String?
    var body: some View {
        Image(uiImage: UIImage(named: (name ?? "Default") + "@3x") ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60)
            .cornerRadius(10)
            .background(
                RoundedRectangle(cornerRadius: 12.65)
                .stroke((name == choice) || (name == "Default" && choice == nil) ? Color.blue : Color.clear , lineWidth: 4)
                .frame(width: 72, height: 72, alignment: .center)
            )
    }
}

struct AlternateIconButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
            AlternateIconButton(choice: .constant("Default"), name: nil)
                .foregroundColor(.white)
                Spacer()
            }
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
