//
//  MainBuilder.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 21.01.24.
//

import UIKit

protocol MainBuilderProtocol: AnyObject {
    func buildTodoList() -> ToDoListController
    func buildCreateVC() -> CreateToDoViewController
    func buildEditVC(todo: ToDoItem) -> EditToDoViewController
}

final class MainBuilder: MainBuilderProtocol {
    
    func buildTodoList() -> ToDoListController {
        let presenter = ToDoListPresenter(todoItems: [[]])
        let todoListVC = ToDoListController(presenter: presenter)
        presenter.view = todoListVC
        return todoListVC
    }
    
    func buildCreateVC() -> CreateToDoViewController {
        let presenter = CreateToDoPresenter()
        let createVC = CreateToDoViewController(presenter: presenter)
        presenter.view = createVC
        return createVC
        
    }
    
    func buildEditVC(todo: ToDoItem) -> EditToDoViewController {
        let presenter = EditToDoPresenter(todoItem: todo)
        let editVC = EditToDoViewController(presenter: presenter)
        presenter.view = editVC
        return editVC
    }
}
