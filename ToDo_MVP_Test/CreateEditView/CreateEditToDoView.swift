//
//  CreateEditToDoView.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 31.01.24.
//

import UIKit

protocol CreateEditTodoViewDelegate: AnyObject {
    func didCreate(with todoItemData: ToDoItemData)
    func didEdit(with todoItemData: ToDoItemData)
    func didTappedAddPictureButton()
}

extension CreateEditTodoViewDelegate {
    func didCreate(with todoItemData: ToDoItemData) {}
    func didEdit(with todoItemData: ToDoItemData) {}
    func didTappedAddPictureButton() {}
}

final class CreateEditTodoView: UIView {
    
    enum ViewType {
        case create
        case edit
    }
    
    private var todoItem: ToDoItem?
    private let viewType: ViewType
    private let appearance = Appearance()
    
    weak var delegate: CreateEditTodoViewDelegate?
    
    init(viewType: ViewType, todoItem: ToDoItem? = nil) {
        self.viewType = viewType
        self.todoItem = todoItem
        super.init(frame: .zero)
        addSubviews()
        layoutViews()
        backgroundColor = .systemBackground
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(mainStackView)
    }
    
    func configure() {
        switch viewType {
        case .create:
            if imageView.image == nil { imageView.isHidden = true }
        case .edit:
            guard let imageData = todoItem?.imageData else { return }
            if todoItem?.imageData == nil { imageView.isHidden = true }
            textField.text = todoItem?.title
            textView.text = todoItem?.description
            dateLabel.text = todoItem?.date?.stringValue
            imageView.image = UIImage(data: imageData)
        }
    }
    
    func configureImageView(with image: UIImage) {
        imageView.isHidden = false
        imageView.image = image
    }
    
    // MARK: - UI Items
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = textFieldConstants.textFieldPlaceholder.localized
        textField.layer.borderColor = textFieldConstants.textFieldLayerBorderColor.cgColor
        textField.layer.borderWidth = textFieldConstants.textFieldLayerBorderWidth
        textField.layer.cornerRadius = textFieldConstants.textFieldLayerCornerRadius
        textField.layer.masksToBounds = true
        
        return textField
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderColor = textViewConstants.textViewLayerBorderColor.cgColor
        textView.layer.borderWidth = textViewConstants.textViewLayerBorderWidth
        textView.layer.cornerRadius = textViewConstants.textViewLayerCornerRadius
        return textView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle(localizeStrings.saveButtonTitle, for: .normal)
        saveButton.layer.cornerRadius = saveButtonConstants.saveButtonLayerCornerRadius
        saveButton.backgroundColor = saveButtonConstants.saveButtonBackgroundColor
        saveButton.addTarget(self, action: #selector(handleSaveButtonTap), for: .touchUpInside)
        return saveButton
    }()
    
    @objc func handleSaveButtonTap() {
        guard let image = imageView.image?.pngData() else { return }
        switch viewType {
        case .create:
            delegate?.didCreate(
                with: ToDoItemData(
                    id: UUID(),
                    title: textField.text ?? .empty,
                    description: textView.text,
                    isCompleted: false,
                    imageData: image,
                    date: datePicker.date
                )
            )
        case .edit:
            guard let todo = self.todoItem else { return }
            delegate?.didEdit(
                with: ToDoItemData(
                    id: todo.id,
                    title: textField.text ?? .empty,
                    description: textView.text,
                    isCompleted: todo.isCompleted,
                    imageData: image,
                    date: datePicker.date
                )
            )
        }
    }
    
    
    private lazy var addPicture: UIButton = {
        let addPicture = UIButton()
        addPicture.translatesAutoresizingMaskIntoConstraints = false
        addPicture.setTitle(localizeStrings.addPictureButtonTitle, for: .normal)
        addPicture.layer.cornerRadius = addPictureLayoutConstants.addPictureLayerCornerRadius
        addPicture.backgroundColor = addPictureLayoutConstants.addPictureBackgroundColor
        addPicture.addTarget(self, action: #selector(handlerAddPictureButton), for: .touchUpInside)
        return addPicture
    }()
    
    @objc func handlerAddPictureButton() {
        delegate?.didTappedAddPictureButton()
    }
    
    private lazy var dateButton: UIButton = {
        let dateButton = UIButton()
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.setTitle(localizeStrings.dateButtonTitle, for: .normal)
        dateButton.layer.cornerRadius = addPictureLayoutConstants.addPictureLayerCornerRadius
        dateButton.backgroundColor = addPictureLayoutConstants.addPictureBackgroundColor
        dateButton.addTarget(self, action: #selector(handlerDateButton), for: .touchUpInside)
        return dateButton
    }()
    
    @objc func handlerDateButton() {
        UIView.animate(withDuration: appearance.animateWithDuration) {
            self.datePicker.isHidden.toggle()
            self.dateLabel.isHidden = false
        }
    }
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        let minDate = Calendar.current.date(byAdding: .day, value: appearance.valueMinDate, to: Date())
        datePicker.minimumDate = minDate
        datePicker.isHidden = true
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: appearance.calendarLocale)
        datePicker.addTarget(self, action: #selector(handlerDatePicker), for: .valueChanged)
        return datePicker
    }()
    
    @objc func handlerDatePicker(sender: UIDatePicker) {
        dateLabel.text = datePicker.date.stringValue
    }
    
    private var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textAlignment = .center
        dateLabel.textColor = .systemBlue
        return dateLabel
    }()
    
    // MARK: - NSLayoutConstraint
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, textField, textView,
                                                       buttonStackView, datePicker, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = appearance.stackViewSpacing
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let buttonStackView = UIStackView(arrangedSubviews: [addPicture, dateButton, saveButton])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .vertical
        buttonStackView.spacing = appearance.buttonStackViewSpacing
        return buttonStackView
    }()
    
    enum layoutViewsConstants {
        static let leadingPadding: CGFloat = 12.0
        static let trailingPadding: CGFloat = -12.0
        static let topMultiplier: CGFloat = 2.0
    }
    
    private func layoutViews() {
        let layoutGuide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: layoutViewsConstants.leadingPadding),
            mainStackView.topAnchor.constraint(equalToSystemSpacingBelow: layoutGuide.topAnchor,
                                               multiplier: layoutViewsConstants.topMultiplier),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: layoutViewsConstants.trailingPadding)
        ])
        layoutTextView()
        layoutImageView()
        layoutButtons()
    }
    
    private func layoutImageView() {
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: appearance.imageViewHeight)
        ])
    }
    
    private func layoutTextView() {
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: textFieldConstants.textFiledHeight)
        ])
        
        NSLayoutConstraint.activate([
            textView.heightAnchor.constraint(equalToConstant: textViewConstants.textViewHeight)
        ])
    }
    
    private func layoutButtons() {
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: saveButtonConstants.saveButtonHeight),
            addPicture.heightAnchor.constraint(equalToConstant: addPictureLayoutConstants.addPictureButtonHeight),
            dateButton.heightAnchor.constraint(equalToConstant: 50.0),
        ])
    }
    
    private func datePickerLayout() {
        NSLayoutConstraint.activate([
            datePicker.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}

// MARK: - Appearance
private extension CreateEditTodoView {
    enum textFieldConstants {
        static let textFiledHeight: CGFloat = 32.0
        static let textFieldPlaceholder: String = "What will the task be called".localized
        static let textFieldLayerBorderWidth: CGFloat = 0.5
        static let textFieldLayerCornerRadius: CGFloat = 8.0
        static let textFieldLayerBorderColor: UIColor = .systemGray2
    }
    
    enum textViewConstants {
        static let textViewHeight: CGFloat = 150.0
        static let textViewLayerBorderWidth: CGFloat = 0.5
        static let textViewLayerCornerRadius: CGFloat = 5.0
        static let textViewLayerBorderColor: UIColor = .systemGray2
    }
    
    enum localizeStrings {
        static let saveButtonTitle: String = "saveButtonTitle".localized
        static let addPictureButtonTitle: String = "Set photo".localized
        static let dateButtonTitle: String = "Set date".localized
    }
    
    enum addPictureLayoutConstants {
        static let addPictureLayerCornerRadius: CGFloat = 5
        static let addPictureBackgroundColor: UIColor = .systemCyan
        static let addPictureButtonHeight: CGFloat = 50.0
    }
    
    enum deleteButtonConstants {
        static let deleteButtonLayerCornerRadius: CGFloat = 5
        static let deleteButtonBackgroundColor: UIColor = .systemRed
    }
    
    enum saveButtonConstants {
        static let saveButtonLayerCornerRadius: CGFloat = 5.0
        static let saveButtonBackgroundColor: UIColor = .systemBlue
        static let saveButtonHeight: CGFloat = 50.0
    }
    
    struct Appearance {
        let stackViewSpacing: CGFloat = 8.0
        let imageViewHeight: CGFloat = 100
        let buttonStackViewSpacing: CGFloat = 10.0
        let calendarLocale: String = "ru_RU"
        let valueMinDate: Int = 0
        let animateWithDuration: Double = 0.5
    }
}
