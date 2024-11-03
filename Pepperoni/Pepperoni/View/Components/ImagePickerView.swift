//
//  SwiftUIView.swift
//  Pepperoni
//
//  Created by Hyun Jaeyeon on 11/3/24.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImageData: Data?
    @Environment(\.dismiss) var dismiss
    var mode: UIImagePickerController.SourceType
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = mode
        imagePicker.allowsEditing = true // 사진 편집 기능
        imagePicker.delegate = context.coordinator
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    
    init(picker: ImagePickerView) {
        self.picker = picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 편집된 이미지 가져오기
        if let editedImage = info[.editedImage] as? UIImage {
            guard let data = editedImage.jpegData(compressionQuality: 0.6) else { return }
            self.picker.selectedImageData = data
        // 편집된 이미지가 없을 경우, 원본 이미지 사용
        } else if let originalImage = info[.originalImage] as? UIImage {
            guard let data = originalImage.jpegData(compressionQuality: 0.6) else { return }
            self.picker.selectedImageData = data
        }
        
        self.picker.dismiss()
    }
}
