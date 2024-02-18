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

final class CreateViewController: UIViewController, CreateEditTodoViewDelegate, CreateViewControllerProtocol {
    
    var presenter: CreatePresenter?
    weak var coordinator: AppCoordinator?
    weak var delegate: CreateViewControllerProtocol?
    lazy var contentView: CreateEditTodoView = {
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
        contentView.configureView()
    }
    
    func didCreate(with todoItemData: ToDoItemData) {
        presenter?.createToDo(with: todoItemData)
        coordinator?.dissmiss()
    }
    
    func didCreateToDo(with item: ToDoItem) {
        guard let date = item.date else { return }
        presenter?.makeNotificationWith(title: item.title, description: item.description, date: date)
        delegate?.didCreateToDo(with: item)
    }
}

