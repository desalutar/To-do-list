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
    
    lazy var contentView: CreateEditTodoView = {
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

