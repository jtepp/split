//
//  NoProfileView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-27.
//

import SwiftUI

struct NoProfileView: View {
    @Binding var m: Member
    @Binding var myId: String
    @Binding var show: Bool
    @Binding var house: House
    @State var name = String()
    @State var newMembers: [String] = []
    @State var showAlert = false
    @State var msg = ""
    @State var img: UIImage?
    var body: some View {
        VStack {
            EditProfileView(show: $show, m: $m, img: $img, name: $name)
            Spacer()
            Button(action: {
                if name.replacingOccurrences(of: " ", with: "") != "" && !newMembers.contains(name) {
                    show = false
                    Fetch().addToWR(m: $m, myId: $myId, h: $house, {})
                } else {
                    msg = name.replacingOccurrences(of: " ", with: "") == "" ? "Name cannot be empty" : "There is already another member in your group with this name"
                    showAlert = true
                }
            }, label: {
                HStack {
                    Spacer()
                    Text("Save")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            name.replacingOccurrences(of: " ", with: "") == "" ? Color.gray : Color.blue
                        )
                )
                .padding()
            })
            .disabled(name.replacingOccurrences(of: " ", with: "") == "")
            .onChange(of: m.id) { (_) in
                UserDefaults.standard.set(m.id, forKey: "myId")
                UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set(m.id, forKey: "myId")
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Account error"), message: Text(msg))
            }
            Spacer(minLength: 80)
                .onAppear(){
                    UserDefaults.standard.set("", forKey: "houseId")
                    UserDefaults.standard.set("", forKey: "myId")
                    UserDefaults.init(suiteName: "group.com.jtepp.spllit")!.set("", forKey: "myId")
                    myId = ""
                }
        }
        
    }
}
