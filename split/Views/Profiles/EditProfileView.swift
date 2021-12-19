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
    @Binding var img: UIImage?
    @State var tempimg: UIImage?
    @Binding var name: String
    @State var showImagePicker = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var cropperShown = false
    var body: some View {
        ScrollView {
            HeaderText(text: "Create your profile", clear: .constant(false))
            VStack {
                b64toimg(b64: m.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(radius: 4)
                    .background(Color.white)
                    .overlay(
                        Menu(content: {
                            Button(action: {
                                showImagePicker = true
                                sourceType = .camera
                            }, label: {
                                Text("Take Picture")
                                Image(systemName: "camera.on.rectangle")
                            })
                            Button(action: {
                                showImagePicker = true
                                sourceType = .photoLibrary
                                
                                
                            }, label: {
                                Text("Choose from Library")
                                Image(systemName: "photo.on.rectangle")
                            })
                            if m.image != "" {
                            Button(action: {
                                m.image = imgtob64(img:b64touiimg(b64: m.image)!.rotate(radians: Float(Double.pi/2))!)
                            }, label: {
                                Text("Rotate photo")
                                Image(systemName: "rotate.right")
                            })
                                Button(action: {
//                                    Fetch().removePhoto(m: $m)
                                    m.image = ""
                                    
                                }, label: {
                                    Text("Remove photo")
                                    Image(systemName: "rectangle.slash")
                                })
                            }
                            
                        }, label: {
                            Image(systemName: "camera.fill")
                                .padding(10)
                                .foregroundColor(.primary)
//                                .preferredColorScheme(.dark)
                                .background(
                                    Circle()
                                        .fill(
                                            Color("Material")
                                        )
                                )
                        })
                        .offset(y: 100)
                    )
                    .padding(.top, -40)
                Spacer()
                InputField(name: "Name", text: $name)
                    .foregroundColor(.primary)
                    .padding()
                    .padding(.top)
                    .onChange(of: name, perform: { value in
                        m.name = name
                    })
            }
            .padding(.vertical, 40)
            .foregroundColor(.white)
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showImagePicker, content: {
                if cropperShown {
                    ImageCroppingView(shown: $cropperShown, image: tempimg ?? UIImage(), croppedImage: $img)
                } else {
                    ImagePicker(img: $tempimg, isShown: $showImagePicker, cropperShown: $cropperShown, sourceType: $sourceType)
                }
            })
            .onChange(of: img, perform: { _ in
                if img != nil {
                    m.image = imgtob64(img: img!.resized(toWidth: 600)!)
                    showImagePicker = false
                }
            })
        }
    }
}
