//
//  CreateViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 23.01.24.
//

import UIKit
import PhotosUI

protocol CreateViewControllerProtocol: AnyObject {
    func didCreateToDo(with item: ToDoItem)
}

extension CreateViewControllerProtocol {
    func didCreateToDo(with item: ToDoItem) {}
}

final class CreateViewController: UIViewController, CreateEditTodoViewDelegate {

    
    
    var presenter: CreatePresenter?
    weak var coordinator: AppCoordinator?
    weak var delegate: CreateViewControllerProtocol?
    private lazy var contentView: CreateEditTodoView = {
        CreateEditTodoView(viewType: .create)
    }()
    
    init(presenter: CreatePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: .main)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = contentView
        contentView.delegate = self
        contentView.configure()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func didCreate(todo: ToDoItem) {
        delegate?.didCreateToDo(with: todo)
        dismiss(animated: true)
    }
}

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
