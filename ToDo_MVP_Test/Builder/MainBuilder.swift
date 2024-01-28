//
//  MainBuilder.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 21.01.24.
//

import UIKit

protocol MainBuilderProtocol: AnyObject {
    func buildTodoList() -> StartViewController
    func buildCreateVC() -> CreateViewController
    func buildEditVC(todo: ToDoItem) -> EditViewController
}

final class MainBuilder: MainBuilderProtocol {
    
    func buildTodoList() -> StartViewController {
        let presenter = StartPresenter(todoItems: [[]])
        let startVC = StartViewController(presenter: presenter)
        presenter.view = startVC
        return startVC
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
        presenter.view = editVC
        return editVC
    }
    
    
}
