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

final class CreateViewController: UIViewController {
    
    var presenter: CreatePresenter?
    weak var coordinator: AppCoordinator?
    weak var delegate: CreateViewControllerProtocol?
    
    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addDateButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    init(presenter: CreatePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: .main)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewsSettings()
        presenter?.imageViewIsHidden(todoImageView)
    }
    
    private func viewsSettings() {
        setupSaveButton()
        setupTextField()
        setupTextView()
        setupDatePicker()
        setupAddDateButton()
    }
    
    private func setupImageView(with image: UIImage) {
        todoImageView.isHidden = false
        todoImageView.image = image
    }
    
    private func setupTextField() {
        let textFieldLayerBorderColor: UIColor = .systemGray2
        titleTextField.layer.borderColor = textFieldLayerBorderColor.cgColor
        titleTextField.placeholder = "Enter task name"
        titleTextField.layer.borderWidth = 0.5
        titleTextField.layer.cornerRadius = 8.0
        titleTextField.layer.masksToBounds = true
    }
    
    private func setupTextView() {
        let textViewLayerBorderColor: UIColor = .systemGray2
        descriptionTextView.layer.borderColor = textViewLayerBorderColor.cgColor
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.cornerRadius = 5.0
    }
    
    private func setupAddDateButton() {
        addPhotoButton.layer.borderWidth = 0.5
        addPhotoButton.layer.cornerRadius = 5.0
        addDateButton.layer.borderWidth = 0.5
        addDateButton.layer.cornerRadius = 5.0
    }
    
    private func setupDatePicker() {
        datePickerLabel.isHidden = true
        datePicker.addTarget(self, action: #selector(handlerDatePicker), for: .valueChanged)
        datePicker.isHidden = true
    }
    @objc func handlerDatePicker(sender: UIDatePicker) {
        datePickerLabel.text = datePicker.date.stringValue
    }
    
    private func setupSaveButton() {
        saveButton.layer.borderWidth = 0.5
        saveButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func addPhotoInToDo(_ sender: Any) {
        didTappedAddPictureButton()
    }
    
    @IBAction func addDateInToDo(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.datePicker.isHidden.toggle()
            self.datePickerLabel.isHidden = false
        }
    }
    
    @IBAction func saveToDo(_ sender: Any) {
        let itemToDo = ToDoItem(title: titleTextField.text ?? .empty, 
                                description: descriptionTextView.text,
                                picture: todoImageView.image, date: datePicker.date)
        delegate?.didCreateToDo(with: itemToDo)
        dismiss(animated: true)
    }
}

extension CreateViewController: ViewControllerPhotosPickerable,
                                ViewControllerAlertPresentable,
                                CameraPresentableDelegate {
    
    func picker(_ picker: PHPickerViewController, didPickedImage image: UIImage) {
        setupImageView(with: image)
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
        setupImageView(with: selectedImage)
    }
}
