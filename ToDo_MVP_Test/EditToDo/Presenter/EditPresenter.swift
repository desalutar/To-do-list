//
//  PresenterEditViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 28.01.24.
//

import Foundation

protocol EditViewControllerPresentable: AnyObject {
    
}

final class EditPresenter: EditViewControllerPresentable {
    weak var view: EditViewControllerProtocol?
    var todoItem: ToDoItem

    init(todoItem: ToDoItem) {
        self.todoItem = todoItem
    }
    
}
