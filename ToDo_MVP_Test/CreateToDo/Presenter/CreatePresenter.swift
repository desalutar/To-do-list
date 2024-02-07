//
//  Presenter.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 23.01.24.
//

import Foundation
import UIKit

protocol CreatePresentable: AnyObject {
    func createToDo(with todoItemData: ToDoItemData)
}

final class CreatePresenter: CreatePresentable {
    weak var view: CreateViewControllerProtocol?
    
    func createToDo(with todoItemData: ToDoItemData) {
        let todoItem = ToDoItem(
            id: todoItemData.id,
            title: todoItemData.title,
            description: todoItemData.description,
            picture: todoItemData.imageData,
            date: todoItemData.date
        )
        view?.didCreateToDo(with: todoItem)
    }
}
