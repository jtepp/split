//
//  ComposeView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-11.
//

import SwiftUI

struct ComposeView: View {
    @State var msg = ""
    var body: some View {
        HStack {
            TextField("Message...", text: $msg, onEditingChanged: { bool in
                print(bool)
            }, onCommit: {
                
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            Button("Send"){}
                .padding(.leading, -8)
                .padding(.trailing)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("DarkMaterial"))
        )
        
        .shadow(radius: 10)
    }
}

struct ComposeView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            Text("Hello")
                .foregroundColor(.white)
                .font(.largeTitle)
                .offset(y:-100)
                .blur(radius: 10)
            ComposeView()
                .padding()
        }
        .preferredColorScheme(.dark)
    }
}
