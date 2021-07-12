//
//  ComposeView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-07-11.
//

import SwiftUI
import MbSwiftUIFirstResponder

struct ComposeView: View {
    @Binding var house: House
    @Binding var members: [Member]
    @Binding var msg: String
    @Binding var show: Bool
    @State var tagmsg = ""
    @State var showTagged = false
    @State var canTap = true
    @Binding var focus: String?
    
//    init(house: Binding<House>, members: Binding<[Member]>, show: Binding<Bool>, focus: Binding<String?>) {
////        UITextField.appearance().clearButtonMode = .whileEditing
//        self._house = house
//        self._members = members
//        self._show = show
//        self._focus = focus
//    }
    
    
    var body: some View {
        VStack {
            TaggedView(tagmsg: $tagmsg, msg: $msg, members: $members, focus: $focus)
                .opacity(showTagged ? 1 : 0)
                .animation(Animation.easeOut.speed(2))
            Spacer()
            HStack {
                TextField("Message...", text: $msg)
                    .firstResponder(id: "msg", firstResponder: $focus, resignableUserOperations: .none)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .overlay(
                        Button{msg = ""} label: {Image(systemName: "plus.circle.fill").rotationEffect(Angle(degrees: 45)).foregroundColor(Color("Material"))}.padding(.trailing, 24)
                            .opacity(msg == "" ? 0 : 1)
                        , alignment: .trailing
                    )
                Button("Send"){
                    if canTap {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        canTap = false
                        Fetch().sendPayment(p: paymentFromMsg(msg), h: house){
                            canTap = true
                            msg = ""
                            show = false
                        }
                    }
                }
                .padding(.leading, -8)
                .padding(.trailing)
                .foregroundColor(canTap ? .blue : .gray)
                .disabled(!canTap)
                .onChange(of: msg, perform: { v in
                    let cp = msg.components(separatedBy: " ")
                    
                    if cp.last == "" && msg != "" {
                        if cp.count > 1 {
                            
                            if cp[cp.count - 2].contains("@") && members.contains(where: { m in
                                return m.name.lowercased().contains(cp[cp.count - 2].replacingOccurrences(of: "@", with: "").lowercased())
                            }) {
                                var fixedcp = cp
                                fixedcp.removeLast()
                                var ls = fixedcp.last
                                fixedcp.removeLast()
                                ls = members.filter( { m in
                                    return m.name.lowercased().contains(cp[cp.count - 2].replacingOccurrences(of: "@", with: "").lowercased())
                                })[0].name
                                
                                msg = fixedcp.joined(separator: " ") + " @" + ls! + " "
                                
                                
                            }
                        }
                    }
                    
                    if ((msg.components(separatedBy: " ").last ?? "").contains("@") && members.contains(where: { mem in
                        return mem.id != UserDefaults.standard.string(forKey: "myId") && mem.name.lowercased().contains((msg.components(separatedBy: " ").last ?? "").replacingOccurrences(of: "@", with: "").lowercased())
                    })) {
                        tagmsg = msg.components(separatedBy: " ").last!
                        showTagged = true
                    } else {
                        tagmsg = ""
                        showTagged = false
                    }
                })
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("DarkMaterial"))
            )
            
            .shadow(radius: 10)
            Spacer()
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
            ComposeView(house: .constant(.empty), members: .constant([.placeholder, .placeholder2, .placeholder3]), msg: .constant(""), show: .constant(true), focus: .constant(""))
                .padding()
        }
        
    }
}

struct TaggedView: View {
    @Binding var tagmsg: String
    @Binding var msg: String
    @Binding var members: [Member]
    @Binding var focus: String?
    var body: some View {
        VStack {
            ForEach(members.filter({ fm in
                return fm.id != UserDefaults.standard.string(forKey: "myId") && fm.name.lowercased().contains(tagmsg.replacingOccurrences(of: "@", with: "").lowercased())
            })) {m in
                Button {
                    var words = msg.components(separatedBy: " ")
                    words.remove(at: words.count - 1)
                    msg = words.joined(separator: " ") + " @" + m.name + " "
                }
                label: {
                    MemberCell(m: .constant(m))
                }
            }
        }
        .frame(minWidth: 200)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("DarkMaterial"))
        )
    }
}


func paymentFromMsg(_ msg: String) -> Payment {
    let rf = msg.components(separatedBy: " ").filter { n in
        return n.contains("@")
    }.map { n in
        return n.replacingOccurrences(of: "@", with: "")
    }
    return Payment(from: UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.string(forKey: "myName") ?? "noname", reqfrom: rf, time: Int(NSDate().timeIntervalSince1970), memo: msg, isGM: true, by: UserDefaults.standard.string(forKey: "myId") ?? "noId")
}
