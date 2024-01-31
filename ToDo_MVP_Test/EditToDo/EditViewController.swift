//
//  EditViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 28.01.24.
//

import UIKit
import PhotosUI

protocol EditViewControllerProtocol: AnyObject {
    func reload()
    func didEditToDo(with todo: ToDoItem)
}

final class EditViewController: UIViewController, CreateEditTodoViewDelegate {

    weak var coordinator: AppCoordinator?
    var delegate: EditViewControllerProtocol?
    var presenter: EditPresenter
    
    private lazy var contentView: CreateEditTodoView = {
        CreateEditTodoView(viewType: .edit, todoItem: presenter.todoItem)
    }()
    
    init(presenter: EditPresenter) {
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
        delegate?.didEditToDo(with: todo)
        coordinator?.popToRootVC()
    }
}

extension EditViewController: ViewControllerPhotosPickerable,
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
    
    private func showCameraPicker() {
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
