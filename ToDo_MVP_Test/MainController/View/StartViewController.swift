//
//  MainViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 20.01.24.
//

import UIKit

protocol StartViewControllerProtocol: AnyObject {
    func reload()
}

typealias DataSource = DiffableDataSource
typealias Snapshot = NSDiffableDataSourceSnapshot<StartViewController.Section, ToDoItem>

final class StartViewController: UIViewController, UITableViewDelegate {
    
    weak var coordinator: AppCoordinator?
    var presenter: StartPresenterProtocol?
    private var dataSource: DataSource?
    @IBOutlet weak var tableView: UITableView!
    
    enum Section {
        case unfulfilled
        case completed
    }
    
    init(presenter: StartPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: String(describing: StartViewController.self), bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 248/255, alpha: 1)
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
    
    private func setTableView() {
        tableView.delegate = self
        tableView.register(Cell.nib(), forCellReuseIdentifier: Cell.cellID)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let todoItem = presenter?.getToDoItem(at: indexPath) else { return }
        coordinator?.showEditViewController(todo: todoItem)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .darkGray
    }
    
    func tableView(_ tableView: UITableView, didDeleteRowWithSwipeActionAt indexPath: IndexPath) {
        
    }
}

extension StartViewController: StartViewControllerProtocol {
    func reload() {
        debugPrint("reload")
    }
}
extension StartViewController: CreateViewControllerProtocol {
    func didCreateToDo(with item: ToDoItem) {
        presenter?.showToDo(with: item)
    }
}

extension StartViewController: EditViewControllerProtocol {
    func didEditToDo(with todo: ToDoItem) {
        presenter?.editToDo(with: todo)
    }
}
