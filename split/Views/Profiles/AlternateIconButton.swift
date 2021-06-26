//
//  AlternateIconButton.swift
//  split
//
//  Created by Jacob Tepperman on 2021-06-24.
//

import SwiftUI

struct AlternateIconButton: View {
    @State var showAlert = false
    @Binding var choice: String
    var name: String
    var body: some View {
        Image(uiImage: UIImage(named: name) ?? UIImage())
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 50)
            .background(
                RoundedRectangle(cornerRadius: 10)
                .stroke((name == choice) ? Color.blue : Color.clear , lineWidth: 4)
                    .frame(width: (name == choice) ? 60 : 40, height: (name == choice) ? 60 : 40, alignment: .center)
            )
            .padding(.horizontal)
            .onTapGesture {
                if choice == name {
                    showAlert = true
                } else {
                    choice = name
                    UIApplication.shared.setAlternateIconName(name == "Default" ? nil : name)
                    UserDefaults.standard.setValue(name, forKey: "alternateIcon")
                }
            }
            .alert(isPresented: $showAlert, content: {
                Alert(title: Text("Having trouble setting the icon?"), message: Text("This is a common iOS glitch. Restart your phone and it should work again.\n\nIf the problem persists, send me a screen recording through the feedback button on the splash screen (tap the ? button on the Activity page)"))
            })
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
