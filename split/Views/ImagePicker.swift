//
//  ImagePicker.swift
//  split
//
//  Created by Jacob Tepperman on 2021-05-26.
//

import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var img: UIImage?
    @Binding var isShown: Bool
    @Binding var cropperShown: Bool
    
    init(img: Binding<UIImage?>, isShown: Binding<Bool>, cropperShown: Binding<Bool>) {
        _img = img
        _isShown = isShown
        _cropperShown = cropperShown
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            img = uiImage
//            isShown = false
            cropperShown = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var img: UIImage?
    @Binding var isShown: Bool
    @Binding var cropperShown: Bool
    @Binding var sourceType: UIImagePickerController.SourceType
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(img: $img, isShown: $isShown, cropperShown: $cropperShown)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
}


