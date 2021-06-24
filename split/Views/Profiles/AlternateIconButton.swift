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
        Image(uiImage: UIImage(named: name+"@3x") ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 60)
            .cornerRadius(10)
            .background(
                RoundedRectangle(cornerRadius: 12.65)
                .stroke((name == choice) ? Color.blue : Color.clear , lineWidth: 4)
                    .frame(width: (name == choice) ? 72 : 40, height: (name == choice) ? 72 : 40, alignment: .center)
            )
            .padding(.horizontal)
            .onTapGesture {
                choice = name
//                UIApplication.shared.setAlternateIconName(name == "Default" ? nil : name)
            }
    }
}

struct AlternateIconButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                AlternateIconButton(choice: .constant("Default"), name: "Default")
                AlternateIconButton(choice: .constant("Default"), name: "Default-inverse")
                Spacer()
            }
            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .animation(.easeOut)
    }
}
