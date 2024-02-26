//
//  CreateViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 23.01.24.
//

import UIKit
import PhotosUI

protocol CreateToDoViewControllerProtocol: AnyObject {
    func didCreateToDo(with item: ToDoItem)
    func presentAlert()
}
extension CreateToDoViewControllerProtocol {
    func presentAlert() {}
}

final class CreateToDoViewController: UIViewController,
                                  CreateEditTodoViewDelegate,
                                  CreateToDoViewControllerProtocol {
    // MARK: - Public properties
    var presenter: CreateToDoPresenter?
    weak var coordinator: AppCoordinator?
    weak var delegate: CreateToDoViewControllerProtocol?
    // MARK: - Private properties
    private lazy var contentView: CreateEditTodoView = {
        CreateEditTodoView(viewType: .create)
    }()
    
    // MARK: - Initialization
    init(presenter: CreateToDoPresenter) {
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
        contentView.configureView()
    }
    
    func didCreate(with todoItemData: ToDoItemData) {
        presenter?.createToDo(with: todoItemData)
        coordinator?.dissmiss()
    }
    
    func didCreateToDo(with item: ToDoItem) {
        delegate?.didCreateToDo(with: item)
    }
}

extension CreateToDoViewController: ViewControllerPhotosPickerable,
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
