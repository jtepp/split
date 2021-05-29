//
//  SplashView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-28.
//

import SwiftUI

struct SplashView: View {
    @Binding var dontSplash: Bool
    var body: some View {
        ScrollView {
            HeaderText(text: "Welcome to split")
            Spacer()
            Button(action: {
                dontSplash = true
                UserDefaults.standard.set(true, forKey: "dontSplash")
            }, label: {
                HStack {
                    Spacer()
                    Text("Ok")
                        .foregroundColor(.white)
                    Spacer()
                }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                    )
                    .padding()
        })
        }
    }
}

struct SplashDetailsView: View {
    let title: String
    let text: String
    let image: String
    var body: some View {
        HStack {
            Image(systemName: image)
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(dontSplash: .constant(false))
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
