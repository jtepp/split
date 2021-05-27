//
//  MemberDetailsView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

struct MemberDetailsView: View {
    @Binding var house: House
    @Binding var member: Member
    @State var showRemove = false
    @Binding var showView: Bool
    @State var showAdminAlert = false
    var body: some View {
        ZStack {
            if house.members.first(where: { (m) -> Bool in
                return m.id == UserDefaults.standard.string(forKey: "myId")
            })?.admin ?? false {
                MenuButton(member: $member, showRemove: $showRemove, showAdminAlert: $showAdminAlert)
                    .alert(isPresented: $showAdminAlert, content: {
                        Alert(title: Text("Set \(member.name) as House admin"), message: Text("Are you sure you want to set \(member.name) as the new House admin? This change can only be reverted by the new admin"), primaryButton: Alert.Button.destructive(Text("Confirm"), action: {
                            Fetch().swapAdmin(m: member, h: house)
                            showView = false
                        }), secondaryButton: Alert.Button.cancel())
                    })
            }
            VStack {
                b64toimg(b64: member.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(radius: 4)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.5))
                    )
                Text(member.name)
                    .font(.largeTitle)
                    .bold()
                if member.admin {
                    Text("House admin")
                }
                Spacer()
                MemberPaymentInfoView(member: $member, house: $house)
                Spacer()
                Text("ID: \(member.id)")
                    .font(.caption)
                    .foregroundColor(Color("Secondary"))
            }
            .padding(.vertical, 40)
            .alert(isPresented: $showRemove, content: {
                Alert(title: Text("Remove \(member.name)"), message: Text("Are you sure you want to remove \(member.name) from this house?"), primaryButton: Alert.Button.destructive(Text("Confirm"), action: {
                    Fetch().removeMember(m: member, h: house)
                    showView = false
                }), secondaryButton: Alert.Button.cancel())
            })
        }
        .foregroundColor(.white)
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct MemberDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")
            .sheet(isPresented: .constant(true), content: {
                MemberDetailsView(house: .constant(.placeholder), member: .constant(Member.placeholder), showView: .constant(true))
                    .preferredColorScheme(.dark)
            })
        
    }
}

struct MenuButton: View {
    @Binding var member: Member
    @Binding var showRemove: Bool
    @Binding var showAdminAlert: Bool
    //attach to house
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Menu(content: {
                    Button("Set as admin", action: {
                        showAdminAlert = true
                    })
                    Button("Remove from house", action: {
                        showRemove = true
                    })
                }, label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(
                            Circle()
                                .fill(
                                    Color.white.opacity(0.2)
                                )
                        )
                        .padding(.vertical)
                        .padding(.horizontal, 10)
                })
            }
            Spacer()
        }
    }
}
