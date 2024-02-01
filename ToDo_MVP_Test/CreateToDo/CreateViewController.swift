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

final class CreateViewController: UIViewController, CreateEditTodoViewDelegate {

    
    
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

