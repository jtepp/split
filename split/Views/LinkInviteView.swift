//
//  LinkInviteView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-06-15.
//

import SwiftUI

struct LinkInviteView: View {
    @Binding var h: House
    @Binding var m: Member
    @Binding var newGroup: String
    @Binding var newPass: String
    @Binding var newName: String
    @Binding var newMembers: [Member]()
    var body: some View {
        VStack{
            HeaderText(text: "Invitation from")
            HStack {
                Text(newName)
                    .font(Font.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                Color.gray.opacity(0.2)
                            )
                )
                
                Spacer()
            }
            .padding(.leading)
            .padding(.top, -20)
            ScrollView {
                ForEach(newMembers) { member in
                    
                }
            }
            .frame(maxHeight: 160)
            .padding(.bottom, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        Color.black.opacity(0.5)
                    )
            )
            Spacer()
            Button(action: {
            }, label: {
                HStack {
                    Spacer()
                    Text("Join")
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
            Button(action: {
            }, label: {
                HStack {
                    Spacer()
                    Text("Cancel")
                        .foregroundColor(.white)
                    Spacer()
                }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.2))
                    )
                .padding(.horizontal)
                .padding(.bottom)
            })
        }
        .onAppear{
            Fetch().returnMembers(hId: newGroup, nm: $newMembers)
        }
    }
}

struct LinkInviteView_Previews: PreviewProvider {
    static var previews: some View {
        LinkInviteView(h: .constant(.placeholder), m: .constant(.placeholder), newGroup: .constant("x9vd0sduWMWT5Zv1FTAD"), newPass: .constant("pass"), newName: .constant("name"))
            .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
