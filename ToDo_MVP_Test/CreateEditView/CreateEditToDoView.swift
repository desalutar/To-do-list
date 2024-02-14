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
        backgroundColor = .systemBackground
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        layoutScrollView()
        layoutMainStackView()
        hideKeyboard()
    }
    
    private func hideKeyboard() {
            let tapper = UITapGestureRecognizer(target: self, action: #selector(endEditing))
            tapper.cancelsTouchesInView = false
            addGestureRecognizer(tapper)
    }

    func configureView() {
        switch viewType {
        case .create:
            if imageView.image == nil { imageView.isHidden = true  }
        case .edit:
            if todoItem?.imageData == nil { imageView.isHidden = true }
            textField.text = todoItem?.title
            textView.text = todoItem?.description
            dateLabel.text = todoItem?.date?.stringValue
            guard let pictureFromData = todoItem?.imageData,
                  let picture = UIImage(data: pictureFromData) else { return }
            imageView.image = picture
        }
        if imageView.image != nil { deletePictureButton.isHidden = false }
    }
    
    func configureImageView(with image: UIImage) {
        imageView.isHidden = false
        deletePictureButton.isHidden = false
        imageView.image = image
    }
    
                        // MARK: - UI Items
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, textField, textView,
                                                       buttonStackView, datePicker, dateLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = appearance.stackViewSpacing
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let buttonStackView = UIStackView(arrangedSubviews: [addPictureButton, deletePictureButton, dateButton, saveButton])
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .vertical
        buttonStackView.spacing = appearance.buttonStackViewSpacing
        return buttonStackView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
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
        textView.delegate = self
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
        saveButton.layer.cornerRadius = buttonConstant.saveButtonLayerCornerRadius
        saveButton.backgroundColor = buttonConstant.saveButtonBackgroundColor
        saveButton.addTarget(self, action: #selector(handleSaveButtonTap), for: .touchUpInside)
        return saveButton
    }()
    
    @objc func handleSaveButtonTap() {
        switch viewType {
        case .create:
            delegate?.didCreate(
                with: ToDoItemData(
                    id: UUID(),
                    title: textField.text ?? .empty,
                    description: textView.text,
                    isCompleted: false,
                    imageData: imageView.image?.pngData(),
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
                    imageData: imageView.image?.pngData(),
                    date: datePicker.date
                )
            )
        }
    }
    
    private lazy var addPictureButton: UIButton = {
        let addPicture = UIButton()
        addPicture.translatesAutoresizingMaskIntoConstraints = false
        addPicture.setTitle(localizeStrings.addPictureButtonTitle, for: .normal)
        addPicture.layer.cornerRadius = buttonConstant.addPictureLayerCornerRadius
        addPicture.backgroundColor = buttonConstant.addPictureBackgroundColor
        addPicture.addTarget(self, action: #selector(handlerAddPictureButton), for: .touchUpInside)
        return addPicture
    }()
    
    @objc func handlerAddPictureButton() {
        delegate?.didTappedAddPictureButton()
    }
    
    private lazy var deletePictureButton: UIButton = {
        let deletePicture = UIButton()
        deletePicture.translatesAutoresizingMaskIntoConstraints = false
        deletePicture.setTitle(localizeStrings.deletePictureButtonTitle, for: .normal)
        deletePicture.layer.cornerRadius = buttonConstant.addPictureLayerCornerRadius
        deletePicture.backgroundColor = .systemCyan
        deletePicture.addTarget(self, action: #selector(handlerDeletePicture), for: .touchUpInside)
        deletePicture.isHidden = true
        return deletePicture
    }()
    
    @objc func handlerDeletePicture() {
        imageView.image = nil
        deletePictureButton.isHidden = true
    }
    
    private lazy var dateButton: UIButton = {
        let dateButton = UIButton()
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        dateButton.setTitle(localizeStrings.dateButtonTitle, for: .normal)
        dateButton.layer.cornerRadius = buttonConstant.addPictureLayerCornerRadius
        dateButton.backgroundColor = buttonConstant.addPictureBackgroundColor
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
    
    private func layoutScrollView() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }
    
    enum layoutViewsConstants {
        static let leadingPadding: CGFloat = 12.0
        static let trailingPadding: CGFloat = -12.0
        static let topMultiplier: CGFloat = 10.0
    }
    
    private func layoutMainStackView() {
        let layoutGuide = scrollView.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: layoutViewsConstants.leadingPadding),
            mainStackView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: layoutViewsConstants.trailingPadding),
            mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: layoutViewsConstants.topMultiplier),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            
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
            saveButton.heightAnchor.constraint(equalToConstant: buttonConstant.saveButtonHeight),
            addPictureButton.heightAnchor.constraint(equalToConstant: buttonConstant.addPictureButtonHeight),
            deletePictureButton.heightAnchor.constraint(equalToConstant: buttonConstant.saveButtonHeight),
            dateButton.heightAnchor.constraint(equalToConstant: buttonConstant.dateButtonHeightConstant),
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
        static let deletePictureButtonTitle: String = "Delete picture".localized
    }
    
    enum buttonConstant {
        static let addPictureLayerCornerRadius: CGFloat = 5
        static let addPictureBackgroundColor: UIColor = .systemCyan
        static let addPictureButtonHeight: CGFloat = 50.0
        
        static let deleteButtonLayerCornerRadius: CGFloat = 5
        static let deleteButtonBackgroundColor: UIColor = .systemRed
        
        static let saveButtonLayerCornerRadius: CGFloat = 5.0
        static let saveButtonBackgroundColor: UIColor = .systemBlue
        static let saveButtonHeight: CGFloat = 50.0
        
        static let dateButtonHeightConstant: CGFloat = 50.0
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
