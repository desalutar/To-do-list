//
//  MainBuilder.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 21.01.24.
//

import UIKit

protocol MainBuilderProtocol: AnyObject {
    func buildTodoList() -> ToDoListController
    func buildCreateVC() -> CreateViewController
    func buildEditVC(todo: ToDoItem) -> EditViewController
}

final class MainBuilder: MainBuilderProtocol {
    
    func buildTodoList() -> ToDoListController {
        let presenter = ToDoListPresenter(todoItems: [[]])
        let todoListVC = ToDoListController(presenter: presenter)
        presenter.view = todoListVC
        return todoListVC
    }
    
    func buildCreateVC() -> CreateViewController {
        let presenter = CreatePresenter()
        let createVC = CreateViewController(presenter: presenter)
        presenter.view = createVC as? any CreateViewControllerProtocol
        return createVC
        
    }
    
    func buildEditVC(todo: ToDoItem) -> EditViewController {
        let presenter = EditPresenter(todoItem: todo)
        let editVC = EditViewController(presenter: presenter)
        presenter.view = editVC as? any EditViewControllerProtocol
        return editVC
    }
}
