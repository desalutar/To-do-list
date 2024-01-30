//
//  Presenter.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 23.01.24.
//

import Foundation
import UIKit

protocol CreatePresentable: AnyObject {
    func imageViewIsHidden(_ imageView: UIImageView)
}

class CreatePresenter: CreatePresentable {
    weak var view: CreateViewControllerProtocol?
    
    func imageViewIsHidden(_ imageView: UIImageView) {
        imageView.isHidden = true
    }
}
