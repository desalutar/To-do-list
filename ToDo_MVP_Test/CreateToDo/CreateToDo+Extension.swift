//
//  CreateToDo+Extension.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 01.02.24.
//

import Foundation

import PhotosUI

extension CreateViewController: ViewControllerPhotosPickerable,
                                ViewControllerAlertPresentable,
                                CameraPresentableDelegate {
    
    func picker(_ picker: PHPickerViewController, didPickedImage image: UIImage) {
        contentView.configureImageView(with: image)
    }
    
    func didTappedAddPictureButton() {
        alertAction { [weak self] source in
            guard let self = self else { return }
            switch source {
            case .gallery:
                showPhotosPicker(with: self)
            case .camera:
                showCameraPicker()
            }
        }
    }
    
    func showCameraPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        contentView.configureImageView(with: selectedImage)
    }
}
