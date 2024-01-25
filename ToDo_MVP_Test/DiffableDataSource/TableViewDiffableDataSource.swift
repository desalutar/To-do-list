//
//  TableViewDiffableDataSource.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 20.01.24.
//

import Foundation
import UIKit

protocol TableViewDiffableDataSourceDelegate: AnyObject {
    func tableView(_ tableView: UITableView, didDeleteRowWithSwipeActionAt indexPath: IndexPath)
}

final class DiffableDataSource: UITableViewDiffableDataSource<StartViewController.Section, ToDoItem> {
    weak var delegate: TableViewDiffableDataSourceDelegate?
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let indexPath = IndexPath(item: 0, section: section)
        guard let todo = itemIdentifier(for: indexPath) else { return nil }
        
        return makeHeaderTitle(with: todo)
    }
    
    private func makeHeaderTitle(with todoItem: ToDoItem) -> String {
        todoItem.isCompleted ? "Completed" : "Unfulfilled"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        delegate?.tableView(tableView, didDeleteRowWithSwipeActionAt: indexPath)
        
    }
}

