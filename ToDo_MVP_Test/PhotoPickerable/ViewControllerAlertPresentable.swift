//
//  ViewControllerAlertPresentable.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 24.01.24.
//

import UIKit
import PhotosUI

protocol ViewControllerAlertPresentable {
    func alertAction(_ action: @escaping (ImagePicker) -> Void)
}

enum ImagePicker {
    case gallery
    case camera
}

extension ViewControllerAlertPresentable where Self: UIViewController {

    func alertAction(_ action: @escaping (ImagePicker) -> Void) {
        let alertTitle: String = "showPhotoPicker_AlertController_Title".localized
        let alertMessage = "showPhotoPicker_AlertController_Message".localized
        let galleryAlertTitle = "Open gallery".localized
        let cameraAlertTitle = "Take Camera".localized
        let cancelAlertTitle = "Cancel".localized
        
        let alert = UIAlertController(title: alertTitle,
                                      message: alertMessage,
                                      preferredStyle: .actionSheet)
        
        let galleryAlertAction = UIAlertAction(title: galleryAlertTitle, style: .default) { _ in
            action(.gallery)
            self.present(alert, animated: true)
        }
        
        let cameraAlertAction = UIAlertAction(title: cameraAlertTitle, style: .default) { _ in
            action(.camera)
            self.present(alert, animated: true)
        }
        
        let cancelAlertAction = UIAlertAction(title: cancelAlertTitle, style: .cancel)
        alert.addAction(galleryAlertAction)
        alert.addAction(cameraAlertAction)
        alert.addAction(cancelAlertAction)
        present(alert, animated: true)
    }
}

