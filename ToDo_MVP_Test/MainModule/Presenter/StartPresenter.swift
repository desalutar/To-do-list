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
    
    func showToDo(with item: ToDoItem)
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
    
    func showToDo(with todoItem: ToDoItem) {
        switch todoItem.isCompleted {
        case true:
            if todoItems.count != 2 {
                todoItems.append([todoItem])
            } else if todoItems.count == 2 {
                todoItems[1].append(todoItem)
            }
        case false:
            if todoItems.isEmpty {
                todoItems.append([todoItem])
            } else if !todoItems[0].isEmpty && (todoItems[0].firstIndex(where: {$0.isCompleted == false}) != nil){
                todoItems[0].append(todoItem)
            } else if todoItems.count == 1 {
                todoItems.insert([todoItem], at: 0)
            } else if todoItems.count == 2 {
                todoItems[0].append(todoItem)
            }
        }
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
        if todoItems.isEmpty {
            dataSource?.apply(snapshot, animatingDifferences: true)
            return
        }
        
        if todoItems.count == 1, let firstSectionTodos = todoItems.first, let firstItem = firstSectionTodos.first {
            if firstItem.isCompleted {
                snapshot.appendSections([.completed])
                snapshot.appendItems(firstSectionTodos, toSection: .completed)
            } else {
                snapshot.appendSections([.unfulfilled])
                snapshot.appendItems(firstSectionTodos, toSection: .unfulfilled)
            }
        } else if todoItems.count == 2 {
            snapshot.appendSections([.unfulfilled, .completed])
            snapshot.appendItems(todoItems[0], toSection: .unfulfilled)
            snapshot.appendItems(todoItems[1], toSection: .completed)
        }
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func getToDoItem(at indexPath: IndexPath) -> ToDoItem? {
        dataSource?.itemIdentifier(for: indexPath)
    }
}
