//
//  MainPresenter.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 21.01.24.
//

import Foundation
import UIKit

protocol MainPresentable: AnyObject {
    var dataSource: DataSource? { get set }
    
    func add(todoItem: ToDoItem)
    func update(todoItemAt indexPath: IndexPath, with todoItem: ToDoItem)
    func delete(todoItemAt indexPath: IndexPath)
    func makeDataSource(for tableView: UITableView)
    func makeSnapshot()
    func getToDoItem(at indexPath: IndexPath) -> ToDoItem?
}

final class StartPresenter: MainPresentable {

    var dataSource: DataSource?  
    private var todoItems: [[ToDoItem]] = []
    weak var view: StartViewControllerProtocol?
    
    init(todoItems: [[ToDoItem]]) {
        self.todoItems = todoItems
    }
    
    func add(todoItem: ToDoItem) {
        debugPrint("add \(todoItem)")
        let testItem = ToDoItem(title: "Bar", description: "Baz", date: .now)
        todoItems[0].append(testItem)
        makeSnapshot()
    }
    
    func update(todoItemAt indexPath: IndexPath, with todoItem: ToDoItem) {
        debugPrint("update at \(indexPath) with \(todoItem)")
    }
    
    func delete(todoItemAt indexPath: IndexPath) {
        debugPrint("delete at \(indexPath)")
    }
    
    func makeDataSource(for tableView: UITableView) {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, todo in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Cell.cellID,
                for: indexPath
            ) as? Cell else { return UITableViewCell() }
            cell.configureCell(with: todo)
            return cell
        }
    }
    
    func makeSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.unfulfilled])
        snapshot.appendItems(todoItems.first!)
        dataSource?.apply(snapshot)
//        if todos.isEmpty {
//            dataSource?.apply(snapshot, animatingDifferences: true)
//            return
//        }
//        
//        if todos.count == 1, let firstSectionTodos = todos.first, let firstItem = firstSectionTodos.first {
//            if firstItem.isCompleted {
//                snapshot.appendSections([.completed])
//                snapshot.appendItems(firstSectionTodos, toSection: .completed)
//            } else {
//                snapshot.appendSections([.unfulfilled])
//                snapshot.appendItems(firstSectionTodos, toSection: .unfulfilled)
//            }
//        } else if todos.count == 2 {
//            snapshot.appendSections([.unfulfilled, .completed])
//            snapshot.appendItems(todos[0], toSection: .unfulfilled)
//            snapshot.appendItems(todos[1], toSection: .completed)
//        }
//        
//        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func getToDoItem(at indexPath: IndexPath) -> ToDoItem? {
        dataSource?.itemIdentifier(for: indexPath)
    }
}
