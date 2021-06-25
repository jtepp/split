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
            .frame(width: 50)
            .cornerRadius(8.8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                .stroke((name == choice) ? Color.blue : Color.clear , lineWidth: 4)
                    .frame(width: (name == choice) ? 60 : 40, height: (name == choice) ? 60 : 40, alignment: .center)
            )
            .padding(.horizontal)
            .onTapGesture {
                choice = name
                UIApplication.shared.setAlternateIconName(name == "Default" ? nil : name)
                UserDefaults.standard.setValue(name, forKey: "alternateIcon")
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
