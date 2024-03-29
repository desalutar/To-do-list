//
//  MainPresenter.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 21.01.24.
//

import Foundation
import UIKit

protocol ToDoListPresentProtocol: AnyObject {
    var dataSource: ToDoListController.DataSource? { get set }

    func showToDo(with item: ToDoItem)
    func makeDataSource(for tableView: UITableView)
    func makeSnapshot()
    func getToDoItem(at indexPath: IndexPath) -> ToDoItem?
    func switchTaskBy(sectionAt indexPath: IndexPath, withItem item: ToDoItem)
    func editToDo(with item: ToDoItem)
    func fetchTodos()
    func makeNotificationWith()
    func showPermissionToReceiveNotifications() 
}

final class ToDoListPresenter: ToDoListPresentProtocol {
    
    // MARK: -  Public  properties
    var dataSource: ToDoListController.DataSource?
    weak var view: ToDoListControllerProtocol?
    
    // MARK: -  Private properties
    private var todoItems: [[ToDoItem]] = []
    private var selectedToDo: UITableView?
    private let coreDataManager = CoreDataManager.shared
    
    // MARK: - Initialization
    init(todoItems: [[ToDoItem]]) {
        self.todoItems = todoItems
    }
    
    func makeDataSource(for tableView: UITableView) {
        dataSource = ToDoListController.DataSource(tableView: tableView) { tableView, indexPath, todo in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Cell.cellID,
                for: indexPath
            ) as? Cell else {
                return UITableViewCell()
            }
            self.selectedToDo = tableView
            cell.delegate = self
            cell.configureCell(with: todo)
            return cell
        }
        dataSource?.delegate = self
    }
    
    func makeSnapshot() {
        var snapshot = ToDoListController.Snapshot()
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
                showPermissionToReceiveNotifications()
            } else if !todoItems[0].isEmpty && (todoItems[0].firstIndex(where: {$0.isCompleted == false}) != nil){
                todoItems[0].append(todoItem)
            } else if todoItems.count == 1 {
                todoItems.insert([todoItem], at: 0)
            } else if todoItems.count == 2 {
                todoItems[0].append(todoItem)
            }
        }
        makeSnapshot()
        coreDataManager.save(todoItem: todoItem)
    }
    
    func getToDoItem(at indexPath: IndexPath) -> ToDoItem? {
        dataSource?.itemIdentifier(for: indexPath)
    }
    
    func editToDo(with item: ToDoItem) {
        if let index = todoItems[0].firstIndex(where: {$0.id == item.id }) {
            todoItems[0].remove(at: index)
            todoItems[0].insert(item, at: index)
        } else if let secondIndex = todoItems[1].firstIndex(where: { $0.id == item.id}) {
            todoItems[1].remove(at: secondIndex)
            todoItems[1].insert(item, at: secondIndex)
        }
        makeSnapshot()
    }
    
    func makeNotificationWith() {
        guard let todosTitle = todoItems.first?.first?.title,
              let todosDescription = todoItems.first?.first?.description,
              let todosDate = todoItems.first?.first?.date else {
            return
        }
        
        let notificationManager = LocalNotificationManager(
            notificationTitle: todosTitle,
            notificationDescription: todosDescription,
            notificationDate: todosDate
        )
        notificationManager.createLocalNotification {
            self.view?.alertToAccessNotifications()
        }
    }
    
    func showPermissionToReceiveNotifications() {
        if todoItems.count >= 1 {
            makeNotificationWith()
        }
    }
}

//MARK: - TableViewCellDelegate
extension ToDoListPresenter: TableViewCellDelegate {
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
            coreDataManager.update(todoItem: item)
        case false:
            if todoItems.count == 1 {
                todoItems.insert([item], at: 0)
            } else if todoItems.count == 2 {
                todoItems[0].append(item)
            }
            if todoItems[1].isEmpty {
                todoItems.remove(at: 1)
            }
            coreDataManager.update(todoItem: item)
        }
    }
    
    func fetchTodos() {
        todoItems = coreDataManager.fetchAllTodos()
        makeSnapshot()
    }
}

// MARK: - TableViewDiffableDataSourceDelegate
extension ToDoListPresenter: TableViewDiffableDataSourceDelegate {
    func tableView(_ tableView: UITableView, didDeleteRowWithSwipeActionAt indexPath: IndexPath) {
        let todo = todoItems[indexPath.section].remove(at: indexPath.row)
        coreDataManager.swipeDeletion(todoItem: todo)
        switch todoItems.count {
        case 1:
            if todoItems[0].isEmpty { todoItems.remove(at: 0) }
        default:
            if todoItems[1].isEmpty { todoItems.remove(at: 1) }
        }
        makeSnapshot()
    }
}
