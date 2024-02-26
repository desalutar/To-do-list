//
//  EditViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 28.01.24.
//

import UIKit
import PhotosUI

protocol EditToDoViewControllerProtocol: AnyObject {
    func didEditToDo(with todo: ToDoItem)
}

final class EditToDoViewController: UIViewController, CreateEditTodoViewDelegate, EditToDoViewControllerProtocol {

    // MARK: - Public properties
    weak var coordinator: AppCoordinator?
    var delegate: EditToDoViewControllerProtocol?
    var presenter: EditToDoPresenter
    
    // MARK: - Private properties
    private lazy var contentView: CreateEditTodoView = {
        CreateEditTodoView(viewType: .edit, todoItem: presenter.todoItem)
    }()
    
    // MARK: - Initialization
    init(presenter: EditToDoPresenter) {
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
    
    func didEdit(with todoItemData: ToDoItemData) {
        presenter.didEditTodo(with: todoItemData)
    }
    
    func didEditToDo(with todo: ToDoItem) {
        delegate?.didEditToDo(with: todo)
        presenter.makeNotificationWith(title: todo.title, description: todo.description, date: todo.date)
        coordinator?.popToListToDoViewController()
    }
}

extension EditToDoViewController: ViewControllerPhotosPickerable,
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
