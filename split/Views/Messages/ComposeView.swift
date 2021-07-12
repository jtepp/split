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
        ZStack {
            HStack {
                TextField("Message...", text: $msg, onEditingChanged: { bool in
                    print(bool)
                }, onCommit: {
                    
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                Button("Send"){
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
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

struct TaggedView: View {
    @Binding var msg: String
    @Binding var members: [Member]
    var body: some View {
        VStack {
            ForEach(members.filter({ fm in
                return fm.id != UserDefaults.standard.string(forKey: "myId") && fm.name.contains(msg)
            })) {m in
                HStack {
                    b64toimg(b64: m.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .shadow(radius: 4)
                        .overlay(
                            Image(systemName: "crown.fill")
                                .offset(x: -3, y: -30)
                                .scaleEffect(x: 1.2)
                                .rotationEffect(.degrees(-30))
                                .foregroundColor(Color.white.opacity(m.admin ? 1 : 0))
                        )
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(m.name)
                            .bold()
                    }
                }
                .foregroundColor(.primary)
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("DarkMaterial"))
        )
    }
}
