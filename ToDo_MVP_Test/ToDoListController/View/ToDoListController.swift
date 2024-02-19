//
//  MainViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 20.01.24.
//

import UIKit

protocol ToDoListControllerProtocol: AnyObject {
    func allowAccessToNotifications()
}

typealias DataSource = DiffableDataSource
typealias Snapshot = NSDiffableDataSourceSnapshot<ToDoListController.Section, ToDoItem>

final class ToDoListController: UIViewController, UITableViewDelegate {
    private var viewBackgroundColor: UIColor = .systemBackground
    weak var coordinator: AppCoordinator?
    var presenter: ToDoListPresentProtocol?
    private var dataSource: DataSource?
    @IBOutlet weak var tableView: UITableView!
    
    enum Section {
        case unfulfilled
        case completed
    }
    
    init(presenter: ToDoListPresentProtocol) {
        self.presenter = presenter
        super.init(nibName: String(describing: ToDoListController.self), bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackgroundColor
        tableView.backgroundColor = viewBackgroundColor
        setTableView()
        setNavigationItems()
        presenter?.makeDataSource(for: tableView)
        presenter?.makeSnapshot()
        presenter?.fetchTodos()
    }
    
    private func setNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDo))
    }
    @objc func addToDo(){
        coordinator?.showCreateViewController()
    }
    
    enum TableViewConstants {
        static let nib: UINib = Cell.nib()
        static let cellID: String = Cell.cellID
    }
    private func setTableView() {
        tableView.delegate = self
        tableView.register(TableViewConstants.nib, forCellReuseIdentifier: TableViewConstants.cellID)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let todoItem = presenter?.getToDoItem(at: indexPath) else { return }
        coordinator?.showEditViewController(todo: todoItem)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .darkGray
    }
}

extension ToDoListController: ToDoListControllerProtocol {
    func allowAccessToNotifications() {
        let alertController = UIAlertController(title: "Enable Notifications?".localized,
                                                message:  "To use this feature you must enable notifications in settings".localized,
                                                preferredStyle: .alert)
        let goToSettings = UIAlertAction(title: "Settings".localized, style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        alertController.addAction(goToSettings)
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .default))
        present(alertController, animated: true)
    }
}
extension ToDoListController: CreateViewControllerProtocol {    
    func didCreateToDo(with item: ToDoItem) {
        presenter?.makeNotificationWith(title: item.title, description: item.description, date: item.date)
        presenter?.showToDo(with: item)
    }
}

extension ToDoListController: EditViewControllerProtocol {
    func didEditToDo(with todo: ToDoItem) {
        presenter?.makeNotificationWith(title: todo.title, description: todo.description, date: todo.date)
        presenter?.editToDo(with: todo)
    }
}
