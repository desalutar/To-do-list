//
//  MainViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 20.01.24.
//

import UIKit

protocol ToDoListControllerProtocol: AnyObject {
    func alertToAccessNotifications()
}

final class ToDoListController: UIViewController {
    typealias DataSource = DiffableDataSource
    typealias Snapshot = NSDiffableDataSourceSnapshot<ToDoListController.Section, ToDoItem>
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: -  Public  properties
    weak var coordinator: AppCoordinator?
    var presenter: ToDoListPresentProtocol?
    
    // MARK: -  Private properties
    private var viewBackgroundColor: UIColor = .systemBackground
    private var dataSource: DataSource?
    
    enum Section {
        case unfulfilled
        case completed
    }
    
    // MARK: - Initialization
    init(presenter: ToDoListPresentProtocol) {
        self.presenter = presenter
        super.init(nibName: String(describing: ToDoListController.self), bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        setupTableView()
        setupNavigationItems()
        presenter?.makeDataSource(for: tableView)
        presenter?.makeSnapshot()
        presenter?.fetchTodos()
    }
    
    private func setupNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDoAction))
    }
    @objc func addToDoAction(){
        coordinator?.showCreateViewController()
    }
    
    enum TableViewConstants {
        static let nib: UINib = Cell.nib()
        static let cellID: String = Cell.cellID
    }
    
    private func setupTableView() {
        tableView.backgroundColor = viewBackgroundColor
        tableView.delegate = self
        tableView.register(TableViewConstants.nib, forCellReuseIdentifier: TableViewConstants.cellID)
    }
}

// MARK: - UITableViewDelegate
extension ToDoListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let todoItem = presenter?.getToDoItem(at: indexPath) else { return }
        coordinator?.showEditViewController(todo: todoItem)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .darkGray
    }
}
// MARK: - ToDoListControllerProtocol
extension ToDoListController: ToDoListControllerProtocol {
    func alertToAccessNotifications() {
        let alertController = UIAlertController(title: "toDoListController.alertTitle".localized,
                                                message:  "toDoListController.alertMessage".localized,
                                                preferredStyle: .alert)
        let goToSettingsAction = UIAlertAction(title: "toDoListController.settings".localized, style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        alertController.addAction(goToSettingsAction)
        alertController.addAction(UIAlertAction(title: "toDoListController.cancel".localized, style: .default))
        present(alertController, animated: true)
    }
}

// MARK: - CreateToDoViewControllerProtocol
extension ToDoListController: CreateToDoViewControllerProtocol {
    func didCreateToDo(with item: ToDoItem) {
        presenter?.showToDo(with: item)
    }
}

// MARK: - EditToDoViewControllerProtocol
extension ToDoListController: EditToDoViewControllerProtocol {
    func didEditToDo(with todo: ToDoItem) {
        presenter?.editToDo(with: todo)
    }
}
