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
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var img: UIImage?
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
                    .overlay(
                        Menu(content: {
                            Button(action: {
                                showImagePicker = true
                                sourceType = .camera
                            }, label: {
                                Text("Take Picture")
                            })
                            Button(action: {
                                showImagePicker = true
                                sourceType = .photoLibrary
                                
                                
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
                    Text("House admin")
                }
                Spacer()
                MemberPaymentInfoView(member: $m, payments: $house.payments)
                Spacer()
                Button(action: {
                    showSignOut = true
                }, label: {
                    HStack {
                        Spacer()
                        Text("Sign Out")
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
                    Alert(title: Text("Sign Out"), message: Text("Please confirm you want to sign out of this account"), primaryButton: Alert.Button.destructive(Text("Confirm"), action: {
                        //signout
                    }), secondaryButton: Alert.Button.cancel())
                })
                Text("ID: \(m.id)")
                    .font(.caption)
                    .foregroundColor(Color("Secondary"))
            }
            .padding(.vertical, 40)
            .foregroundColor(.white)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(img: $img, isShown: $showImagePicker, sourceType: sourceType)
            })
            
            
//            .onAppear{
//                UserDefaults.standard.set(m.name, forKey: "name")
//                UserDefaults.standard.set(m.id, forKey: "myId")
//            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(house: .constant(.placeholder), m: .constant(.placeholder))
    }
}
