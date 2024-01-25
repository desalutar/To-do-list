//
//  ViewControllerPhotosPickerable.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 24.01.24.
//

import PhotosUI

protocol ViewControllerPhotosPickerable: PHPickerViewControllerDelegate {
    func showPhotosPicker(with delegate: PHPickerViewControllerDelegate)
    func picker(_ picker: PHPickerViewController, didPickedImage image: UIImage)
}

extension ViewControllerPhotosPickerable where Self: UIViewController {
    
    func showPhotosPicker(with delegate: PHPickerViewControllerDelegate) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = delegate
        present(pickerViewController, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] itemProviderReading, error in
                guard let image = itemProviderReading as? UIImage, error == nil else { return }
                DispatchQueue.main.async {
                    self?.picker(picker, didPickedImage: image)
                }
            }
        }
    }
}

