//
//  CameraPresentable.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 24.01.24.
//

import UIKit

typealias CameraPresentableDelegate = UIImagePickerControllerDelegate & UINavigationControllerDelegate

enum CameraError: Error {
    case cameraUnavailable
}

protocol CameraPresentable: CameraPresentableDelegate {
    func showCameraPicker(delegate: CameraPresentableDelegate) throws
    func picker(_ picker: UIImagePickerController, didPickedImage image: UIImage)
}

extension CameraPresentable where Self: UIViewController {
    func showCameraPicker(delegate: CameraPresentableDelegate) throws {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            throw CameraError.cameraUnavailable
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.allowsEditing = true
        picker.delegate = delegate
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        self.picker(picker, didPickedImage: selectedImage)
    }
}
