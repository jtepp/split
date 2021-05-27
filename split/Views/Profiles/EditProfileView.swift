//
//  EditProfileView.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-27.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var show: Bool
    @Binding var m: Member
    @State var img: UIImage?
    @State var name = String()
    @State var showImagePicker = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    var body: some View {
        ScrollView {
            HeaderText(text: "Edit your profile")
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
                    .padding(.top, -40)
                Spacer()
                InputField(name: "Name", text: $name)
                    .foregroundColor(.black)
                    .padding()
                    .padding(.top)
                Spacer()
                Button(action: { /*************************************                                                     ONLY IF FIELDS ARE FILLED                                                                                                   *******************************************/
                    //save profile
                    if name.replacingOccurrences(of: " ", with: "") != "" {
                        show = false
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
                Spacer(minLength: 80)
            }
            .padding(.vertical, 40)
            .foregroundColor(.white)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showImagePicker, content: {
                ImagePicker(img: $img, isShown: $showImagePicker, sourceType: sourceType)
            })
            .onChange(of: img, perform: { _ in
                if img != nil {
                    m.image = imgtob64(img: img!)
                }
            })
        }
    }
}
