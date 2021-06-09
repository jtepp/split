//
//  ProfileView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct ProfileView: View {
    @Binding var house: House
    @Binding var m: Member
    @State var showSignOut = false
    @State var showImagePicker = false
    @State var showAdminPicker = false
    @State var showSheet = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var adminChoice = [Member]()
    @State var img: UIImage?
    @Binding var inWR: Bool
    var body: some View {
        ScrollView {
            HeaderText(text: "Profile")
            VStack {
                b64toimg(b64: m.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(radius: 4)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.white.opacity(0.5))
                    )
                    .overlay(
                        Menu(content: {
                            Button(action: {
                                sourceType = .camera
                                showImagePicker = true
                                showSheet = true
                            }, label: {
                                Text("Take Picture")
                            })
                            Button(action: {
                                sourceType = .photoLibrary
                                showImagePicker = true
                                showSheet = true
                                
                                
                            }, label: {
                                Text("Choose from Library")
                            })
                            
                        }, label: {
                            Image(systemName: "camera.fill")
                                .padding(10)
                                .foregroundColor(.black)
                                .background(
                                    Circle()
                                        .fill(
                                            Color.gray
                                        )
                                )
                        })
                        .offset(y: 100)
                    )
                Text(m.name)
                    .font(.largeTitle)
                    .bold()
                if m.admin {
                    Text("Group admin")
                }
                Spacer()
                if (UserDefaults.standard.string(forKey: "houseId") ?? "") != "" && (UserDefaults.standard.string(forKey: "houseId") ?? "") != "waitingRoom" {
                    MemberPaymentInfoView(member: $m, house: $house)
                    Spacer()
                    Button(action: {
                        showSignOut = true
                    }, label: {
                        HStack {
                            Spacer()
                            Text("Delete account")
                                .foregroundColor(.red)
                            Spacer()
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    Color.white.opacity(0.2)
                                )
                        )
                        .padding()
                    })
                    .alert(isPresented: $showSignOut, content: {
                        if m.admin {
                            if house.members.count > 1 {
                                return Alert(title: Text("Set a new admin"), message: Text("You have to choose a new Group admin before you can delete this account"), primaryButton: Alert.Button.destructive(Text("Choose admin"), action: {
                                    showAdminPicker = true
                                    showSheet = true
                                }), secondaryButton: Alert.Button.cancel())
                            } else {
                                return Alert(title: Text("Erase Group"), message: Text("Deleting this account will erase this group from the database"), primaryButton: Alert.Button.destructive(Text("Erase"), action: {
                                    Fetch().deleteAccount(m: $m, erase: true, inWR: $inWR)
                                }), secondaryButton: Alert.Button.cancel())
                            }
                        } else {
                            return Alert(title: Text("Delete account"), message: Text("Are you sure you want to delete this acount?"), primaryButton: Alert.Button.destructive(Text("Confirm"), action: {
                                Fetch().deleteAccount(m: $m, inWR: $inWR)
                            }), secondaryButton: Alert.Button.cancel())
                        }
                    })
                }
                Text("ID: \(m.id)")
                    .font(.caption)
                    .foregroundColor(Color("Secondary"))
                Spacer(minLength: 80)
            }
            .padding(.vertical, 40)
            .foregroundColor(.white)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onChange(of: img, perform: { _ in
                if img != nil {
                    Fetch().updateImg(img: img!, hId: house.id, myId: m.id)
                }
            })
            .onAppear{
                UserDefaults.standard.set(m.id, forKey: "myId")
                //                Fetch().updateMember(m: $m)
            }
            .sheet(isPresented: $showSheet, onDismiss: {
                if !adminChoice.isEmpty {
                    Fetch().swapAdmin(m: adminChoice.first!, h: house)
                }
                showImagePicker = false
                showAdminPicker = false
            }, content: {
                if showImagePicker {
                    ImagePicker(img: $img, isShown: $showSheet, sourceType: $sourceType)
                }
                if showAdminPicker {
                    MemberPicker(show: $showSheet, house: $house, choice: $adminChoice)
                }
            })
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(house: .constant(.placeholder), m: .constant(.placeholder))
//    }
//}
