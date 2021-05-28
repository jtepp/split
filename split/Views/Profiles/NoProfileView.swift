//
//  NoProfileView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-27.
//

import SwiftUI

struct NoProfileView: View {
    @Binding var myId: String
    @Binding var show: Bool
    @Binding var house: House
    @State var newMember = Member.empty
    @State var name = String()
    @State var img: UIImage?
    var body: some View {
        VStack {
            EditProfileView(show: $show, m: $newMember, img: $img, name: $name)
            Spacer()
            Button(action: {
                if name.replacingOccurrences(of: " ", with: "") != "" {
                    show = false
                    Fetch().addToWR(m:newMember, myId: $myId, h: $house)
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
            .onChange(of: newMember.id) { (_) in
                UserDefaults.standard.set(newMember.id, forKey: "myId")
            }
            Spacer(minLength: 80)
                .onAppear(){
                    UserDefaults.standard.set("", forKey: "houseId")
                    UserDefaults.standard.set("", forKey: "myId")
                    myId = ""
                }
        }
        
    }
}
