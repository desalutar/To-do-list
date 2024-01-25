//
//  Presenter.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 23.01.24.
//

import Foundation
import UIKit

protocol CreatePresentable: AnyObject {
    func saveToDoInArray(with item: ToDoItem)
    func imageViewIsHidden(_ imageView: UIImageView)
}

class CreatePresenter: CreatePresentable {
    weak var view: CreateViewControllerProtocol?
    private var todos = [[ToDoItem]]()
    
    func saveToDoInArray(with item: ToDoItem) {
        switch item.isCompleted {
        case true:
            if todos.count != 2 {
                todos.append([item])
            } else if todos.count == 2 {
                todos[1].append(item)
            }
        case false:
            if todos.isEmpty {
                todos.append([item])
            } else if !todos[0].isEmpty && (todos[0].firstIndex(where: {$0.isCompleted == false}) != nil){
                todos[0].append(item)
            } else if todos.count == 1 {
                todos.insert([item], at: 0)
            } else if todos.count == 2 {
                todos[0].append(item)
            }
        }
    }
    
    func imageViewIsHidden(_ imageView: UIImageView) {
        imageView.isHidden = true
    }
}
