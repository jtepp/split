//
//  ProfileView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-25.
//

import SwiftUI

struct ProfileView: View, KeyboardReadable {
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
    @Binding var noProf: Bool
    @Binding var showStatus: Bool
    @State var keyboardOpen = false
    @Binding var newName: String
    var body: some View {
        ScrollView {
            HStack {
                HeaderText(text: "Profile")
                Spacer()
                Menu {
                    Button {
                        if showStatus {
                            showStatus = false
                            Fetch().toggleShowStatus(s: false)
                        } else {
                            showStatus = true
                            Fetch().toggleShowStatus(s: true)
                        }
                        UserDefaults.standard.setValue(showStatus, forKey: "status")
                        UserDefaults.standard.setValue(true, forKey: "statusSet")
                        print("STATUSSET\(UserDefaults.standard.bool(forKey: "statusSet"))")
                    } label: {
                        Text("Show Status")
                        Image(systemName: showStatus ? "circlebadge.fill" : "circlebadge")
                            .renderingMode(.original)
                            .foregroundColor(
                                showStatus ? .green : .black
                            )
                    }

                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.white)
                        .font(Font.body.bold())
                        .padding(18)
                        .background(
                            Circle()
                                .fill(
                                    Color("DarkMaterial")
                                )
                        )
                }
                
            }
            VStack {
                b64toimg(b64: m.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(radius: 4)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color("Material"))
                    )
                    .overlay(
                        Menu(content: {
                            Button(action: {
                                sourceType = .camera
                                showImagePicker = true
                                showSheet = true
                            }, label: {
                                Text("Take Picture")
                                Image(systemName: "camera.on.rectangle")
                            })
                            Button(action: {
                                sourceType = .photoLibrary
                                showImagePicker = true
                                showSheet = true
                                
                                
                            }, label: {
                                Text("Choose from Library")
                                Image(systemName: "photo.on.rectangle")
                            })
                            if m.image != "" {
                                Button(action: {
                                    Fetch().removePhoto(m: $m)
                                    
                                    
                                }, label: {
                                    Text("Remove photo")
                                    Image(systemName: "rectangle.slash")
                                })
                            }
                            
                        }, label: {
                            Image(systemName: "camera.fill")
                                .padding(10)
                                .shadow(radius: 2)
                                .foregroundColor(.primary)
                                .background(
                                    Circle()
                                        .fill(
                                            Color("Material")
                                        )
                                )
                        })
                        .offset(y: 100)
                    )
                
                TextField("Name", text: $newName)
                    .disableAutocorrection(true)
                .font(Font.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 10)
                .overlay(
                    HStack {
                        Spacer()
                        if keyboardOpen {
                            Button(action: {
                                print(newName)
                                Fetch().changeName(m: $m, newName: $newName){
                                    Fetch().getHouse(h: $house, m: $m, inWR: $inWR, noProf: $noProf)
                                }
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }, label: {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.black)
                                    .font(Font.body.bold())
                                    .padding(4)
                                    .background(
                                        Circle()
                                            .fill(
                                                Color.white                                        )
                                    )
                            })
                            
                        }
                    }
                )
                .onReceive(keyboardPublisher, perform: { k in
                    keyboardOpen = k
                })
                if m.admin {
                    Text("Group Admin")
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
                                    Color("DarkMaterial")
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
                                    Fetch().deleteAccount(m: $m, erase: true, inWR: $inWR){
                                        Fetch().getHouse(h: $house, m: $m, inWR: $inWR, noProf: $noProf)
                                    }
                                }), secondaryButton: Alert.Button.cancel())
                            }
                        } else {
                            return Alert(title: Text("Delete account"), message: Text("Are you sure you want to delete this acount?"), primaryButton: Alert.Button.destructive(Text("Confirm"), action: {
                                Fetch().deleteAccount(m: $m, inWR: $inWR){
                                    Fetch().getHouse(h: $house, m: $m, inWR: $inWR, noProf: $noProf)
                                }
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
            .onChange(of: m, perform: { _ in
                newName = m.name
                Fetch().getHouse(h: $house, m: $m, inWR: $inWR, noProf: $noProf)
            })
            .onAppear{
                UserDefaults.standard.set(m.id, forKey: "myId")
                newName = m.name
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
        
            if UIApplication.shared.supportsAlternateIcons {
                
                Rectangle()
                    .fill(
                        Color.black
                    )
                    .frame(height: 200)
                    .onAppear{
                        UIApplication.shared.setAlternateIconName("Default-inverse"){err in
                            print("NOOO \(err?.localizedDescription)")
                        }
                    }
                VStack(alignment: .leading) {
                    HeaderText(text: "App icons")
                    Text("Default")
                        .font(Font.title2.weight(.semibold))
                        .padding(.leading)
                    Text("Depth")
                        .font(Font.title2.weight(.semibold))
                        .padding(.leading)
                    Text("Rainbow")
                        .font(Font.title2.weight(.semibold))
                        .padding(.leading)
                    Text("more coming soon...")
                        .font(.subheadline)
                        .padding()
                    
                    
                    
                    Spacer(minLength: 80)
                    
                }
                .foregroundColor(.white)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(house: .constant(.placeholder), m: .constant(.placeholder), inWR: .constant(false), noProf: .constant(false), showStatus: .constant(true), newName: .constant(""))
            .background(Color.black.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}
