//
//  CreateViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 23.01.24.
//

import UIKit

protocol CreateViewControllerProtocol: AnyObject {
    func reloadCreate()
}

class CreateViewController: UIViewController {
    
    var present: CreatePresenter?
    weak var coordinator: AppCoordinator?
    
    @IBOutlet weak var todoImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var addDateButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    init(presenter: CreatePresenter) {
        self.present = presenter
        super.init(nibName: nil, bundle: .main)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingButtonLayer()
        settingButton()
        present?.imageViewIsHidden(todoImageView)
    }

    private func settingButtonLayer() {
        titleTextField.borderStyle = .roundedRect
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.cornerRadius = 5.0
        addPhotoButton.layer.borderWidth = 0.5
        addPhotoButton.layer.cornerRadius = 5.0
        addDateButton.layer.borderWidth = 0.5
        addDateButton.layer.cornerRadius = 5.0
        saveButton.layer.borderWidth = 0.5
        saveButton.layer.cornerRadius = 5.0
    }
    private func settingButton() {
        datePickerLabel.isHidden = true
        datePicker.addTarget(self, action: #selector(handlerDatePicker), for: .valueChanged)
        datePicker.isHidden = true
    }
    @objc func handlerDatePicker(sender: UIDatePicker) {
        datePickerLabel.text = datePicker.date.stringValue
    }
    
    @IBAction func addPhotoInToDoButton(_ sender: Any) {
        
    }
    @IBAction func addDateInToDoButton(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.datePicker.isHidden.toggle()
            self.datePickerLabel.isHidden = false
        }
    }
    
    @IBAction func saveToDoButton(_ sender: Any) {
        let createTodo = ToDoItem(title: titleTextField.text ?? "", description: descriptionTextView.text, date: nil)
        present?.saveToDoInArray(with: createTodo)
        dismiss(animated: true)
    }
}

extension CreateViewController: CreateViewControllerProtocol {
    func reloadCreate() {
        print("123")
    }
}
