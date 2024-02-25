//
//  Presenter.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 23.01.24.
//

import Foundation
import UIKit

protocol CreateToDoPresentable: AnyObject {
    func createToDo(with todoItemData: ToDoItemData)
}

final class CreateToDoPresenter: CreateToDoPresentable {
    weak var view: CreateToDoViewControllerProtocol?
    
    func createToDo(with todoItemData: ToDoItemData) {
        let todoItem = ToDoItem(
            id: todoItemData.id,
            isCompleted: todoItemData.isCompleted,
            title: todoItemData.title,
            description: todoItemData.description,
            picture: todoItemData.imageData,
            date: todoItemData.date
        )
        view?.didCreateToDo(with: todoItem)
    }
}
