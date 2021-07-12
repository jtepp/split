//
//  ComposeView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-11.
//

import SwiftUI

struct ComposeView: View {
    @Binding var members: [Member]
    @State var msg = "hey @joh"
    @State var tagmsg = ""
    @State var showTagged = false
    var body: some View {
        ZStack {
            HStack {
                TextField("Message...", text: $msg, onEditingChanged: { bool in
                    
                    if (msg.components(separatedBy: " ").last ?? "").contains("@") {
                        tagmsg = msg.components(separatedBy: " ").last!
                        withAnimation(.easeOut.speed(2)) {
                            showTagged = true
                        }
                    } else {
                        tagmsg = ""
                        withAnimation(.easeOut.speed(2)) {
                            showTagged = false
                        }
                    }
                    
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
            
            VStack {
                TaggedView(tagmsg: $tagmsg, members: $members)
                    .offset(y: showTagged ? 0: -600)
                Spacer()
            }
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
            ComposeView(members: .constant([.placeholder, .placeholder2, .placeholder3]))
                .padding()
        }
        
    }
}

struct TaggedView: View {
    @Binding var tagmsg: String
    @Binding var members: [Member]
    var body: some View {
        VStack {
            ForEach(members.filter({ fm in
                return fm.id != UserDefaults.standard.string(forKey: "myId") && fm.name.lowercased().contains(tagmsg.lowercased())
            })) {m in
                Button {}
                    label: {
                        MemberCell(m: .constant(m))
                    }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("DarkMaterial"))
        )
        .frame(minWidth: 200)
    }
}
