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
    var presenter: MainPresentable?
    private var dataSource: DataSource?
    @IBOutlet weak var tableView: UITableView!
    
    enum Section {
        case unfulfilled
        case completed
    }
    
    init(presenter: MainPresentable) {
        self.presenter = presenter
        super.init(nibName: String(describing: StartViewController.self), bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setNavigationItems()
        let testTodo = ToDoItem(title: "Foo", description: "Bar", date: .now)
        presenter?.add(todoItem: testTodo)
        presenter?.makeDataSource(for: tableView)
    }
    
    private func setNavigationItems() {
        let addToDoButton = UIButton(type: .contactAdd)
        addToDoButton.addTarget(self, action: #selector(logoutUser), for: .touchUpInside)
        let navigationAddButton = UIBarButtonItem(customView: addToDoButton)
        navigationItem.rightBarButtonItem = navigationAddButton
    }
    @objc func logoutUser(){
        coordinator?.showCreateViewController()
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.register(Cell.nib(), forCellReuseIdentifier: Cell.cellID)
        
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        guard let item = presenter?.getToDoItem(at: indexPath) else { return }
    //        // coordinator.navigateToEdit(todoItem: item)
    //    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
}

extension StartViewController: StartViewControllerProtocol {
    func reload() {
        debugPrint("reload")
    }
}

extension StartViewController: TableViewDiffableDataSourceDelegate {
    func tableView(_ tableView: UITableView, didDeleteRowWithSwipeActionAt indexPath: IndexPath) {
    }
}
