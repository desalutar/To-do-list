//
//  EditViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 28.01.24.
//

import UIKit

protocol EditViewControllerProtocol: AnyObject {
    func reload() 
    func configureToDo(with item: ToDoItem)
}

class EditViewController: UIViewController {

    weak var coordinator: AppCoordinator?
    var presenter: EditPresenter
    
    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerLabel: UILabel!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addDateButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    init(presenter: EditPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: .main)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewsSettings()
    }
    
    private func viewsSettings() {
        settingsSaveButton()
        settingsTextField()
        settingsTextView()
        settingDatePicker()
        settingsAddDateButton()
//        configureToDo(with: presenter.todoItem)
        presenter.configureToDo(with: presenter.todoItem)
    }
    
    func settingsImageView(with image: UIImage) {
        todoImageView.isHidden = false
        todoImageView.image = image
    }
    
    private func settingsTextField() {
        let textFieldLayerBorderColor: UIColor = .systemGray2
        titleTextField.layer.borderColor = textFieldLayerBorderColor.cgColor
        titleTextField.placeholder = "Enter task name"
        titleTextField.layer.borderWidth = 0.5
        titleTextField.layer.cornerRadius = 8.0
        titleTextField.layer.masksToBounds = true
    }
    
    private func settingsTextView() {
        let textViewLayerBorderColor: UIColor = .systemGray2
        descriptionTextView.layer.borderColor = textViewLayerBorderColor.cgColor
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.cornerRadius = 5.0
    }
    
    fileprivate func settingsAddDateButton() {
        addPhotoButton.layer.borderWidth = 0.5
        addPhotoButton.layer.cornerRadius = 5.0
        addPhotoButton.layer.borderWidth = 0.5
        addPhotoButton.layer.cornerRadius = 5.0
    }
    
    private func settingDatePicker() {
        datePickerLabel.isHidden = true
        datePicker.addTarget(self, action: #selector(handlerDatePicker), for: .valueChanged)
        datePicker.isHidden = true
    }
    @objc func handlerDatePicker(sender: UIDatePicker) {
        datePickerLabel.text = datePicker.date.stringValue
    }
    
    private func settingsSaveButton() {
        saveButton.layer.borderWidth = 0.5
        saveButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func addPhotoButton(_ sender: Any) {
        
    }
    
    @IBAction func addDateButton(_ sender: Any) {
        
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
    }
}
