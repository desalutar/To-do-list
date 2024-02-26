//
//  PresenterEditViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 28.01.24.
//

import Foundation

protocol EditToDoViewControllerPresentable: AnyObject {
    func didEditTodo(with data: ToDoItemData)
}

final class EditToDoPresenter: EditToDoViewControllerPresentable {
    // MARK: - Public properties
    var todoItem: ToDoItem
    weak var view: EditToDoViewControllerProtocol?
    
    // MARK: - Initialization
    init(todoItem: ToDoItem) {
        self.todoItem = todoItem
    }
    
    func didEditTodo(with data: ToDoItemData) {
        let todoItem = ToDoItem(
            id: data.id,
            title: data.title,
            description: data.description,
            picture: data.imageData,
            date: data.date
        )
        view?.didEditToDo(with: todoItem)
    }
}
