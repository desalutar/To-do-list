//
//  PresenterEditViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 28.01.24.
//

import Foundation

protocol EditViewControllerPresentable: AnyObject {
    func didEditTodo(with data: ToDoItemData)
}

final class EditPresenter: EditViewControllerPresentable {
    weak var view: EditViewControllerProtocol?
    var todoItem: ToDoItem

    init(todoItem: ToDoItem) {
        self.todoItem = todoItem
    }
    
    func didEditTodo(with data: ToDoItemData) {
        let todoItem = ToDoItem(
            id: data.id,
            title: data.title,
            description: data.description,
            date: data.date
        )
        view?.didEditToDo(with: todoItem)
    }
}
