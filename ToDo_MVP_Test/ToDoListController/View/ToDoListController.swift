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

// Эти тайпалиасы я думаю лучше засунуть внутрь класса. Просто тут название алиаса такое дженерик... `DataSource` и `Snapshot`
typealias DataSource = DiffableDataSource
typealias Snapshot = NSDiffableDataSourceSnapshot<ToDoListController.Section, ToDoItem>

final class ToDoListController: UIViewController, UITableViewDelegate {
    
    /*
     По код стайлу мы объявляем сначала публичные свойства, а потом приватные
     Еще можно их разделять марками // MARK: -
     */
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Public properties
    
    weak var coordinator: AppCoordinator?
    var presenter: ToDoListPresentProtocol?
    
    // MARK: - Private properties
    
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
        
        // это можно вынести в `setTableView`. и еще, это название кривое
        // `setupTableView` / `configureTableView`
        tableView.backgroundColor = viewBackgroundColor
        setTableView()
        
        // `setupNavigationItems`
        setNavigationItems()
        presenter?.makeDataSource(for: tableView)
        presenter?.makeSnapshot()
        presenter?.fetchTodos()
    }
    
    private func setNavigationItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToDo))
    }
    
    // 💩 addToDoAction
    @objc func addToDo(){
        coordinator?.showCreateViewController()
    }
    
    enum TableViewConstants {
        static let nib: UINib = Cell.nib()
        static let cellID: String = Cell.cellID
    } // пустую строку между enum и методом
    private func setTableView() {
        tableView.delegate = self
        tableView.register(TableViewConstants.nib, forCellReuseIdentifier: TableViewConstants.cellID)
    }
    
    // Тут желательно вынести в extension и пометить маркой что это UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let todoItem = presenter?.getToDoItem(at: indexPath) else { return }
        coordinator?.showEditViewController(todo: todoItem)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .darkGray
    }
}

// К каждому конформу протоколу желательно сделать марк. Так легче видеть в меню навинации файла

extension ToDoListController: ToDoListControllerProtocol {
    
    // почему `allow....Notification` ? А что если юзер не allow ? Почему метод так называется ? Он что, разрешает доступ к нотификациям ?
    func allowAccessToNotifications() {
        let alertController = UIAlertController(title: "Enable Notifications?".localized,
                                                message:  "To use this feature you must enable notifications in settings".localized,
                                                preferredStyle: .alert)
        
        // goToSettingsAction
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
} // Enter
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
