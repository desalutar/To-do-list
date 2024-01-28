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
    func switchTaskBy(sectionAt indexPath: IndexPath, withItem item: ToDoItem)
}

final class StartPresenter: MainPresentable {

    var dataSource: DataSource?  
    private var todoItems: [[ToDoItem]] = []
    weak var view: StartViewControllerProtocol?
    private var selectedToDo: UITableView?
    
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
            self.selectedToDo = tableView
            cell.delegate = self
            cell.configureCell(with: todo)
            return cell
        }
        dataSource?.delegate = self
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

extension StartPresenter: TableViewCellDelegate {
    func toggleTaskAtSection(_ cell: Cell) {
         guard let indexPath = selectedToDo?.indexPath(for: cell),
              var item = dataSource?.itemIdentifier(for: indexPath) else { return }
        switch !item.isCompleted {
        case true:
            item.isCompleted = true
            todoItems[indexPath.section].remove(at: indexPath.row)
            switchTaskBy(sectionAt: indexPath, withItem: item)
        case false:
            item.isCompleted = false
            todoItems[indexPath.section].remove(at: indexPath.row)
            switchTaskBy(sectionAt: indexPath, withItem: item)
        }
        makeSnapshot()
    }
    
    func switchTaskBy(sectionAt indexPath: IndexPath, withItem item: ToDoItem) {
        switch item.isCompleted {
        case true:
            if todoItems.count != 2 {
                todoItems.append([item])
            } else if todoItems.count == 2 {
                todoItems[1].append(item)
            }
            if todoItems[0].isEmpty {
                todoItems.remove(at: 0)
            }
            
        case false:
            if todoItems.count == 1 {
                todoItems.insert([item], at: 0)
            } else if todoItems.count == 2 {
                todoItems[0].append(item)
            }
            if todoItems[1].isEmpty {
                todoItems.remove(at: 1)
            }
        }
    }
}

extension StartPresenter: TableViewDiffableDataSourceDelegate {
    func tableView(_ tableView: UITableView, didDeleteRowWithSwipeActionAt indexPath: IndexPath) {
        todoItems[indexPath.section].remove(at: indexPath.row)
        
        switch todoItems.count {
        case 1:
            if todoItems[0].isEmpty { todoItems.remove(at: 0) }
        default:
            if todoItems[1].isEmpty { todoItems.remove(at: 1) }
        }
        makeSnapshot()
    }
}
