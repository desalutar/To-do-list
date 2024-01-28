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
    weak var view: EditViewController?
    var viewType: ViewType
    var todoItems: [[ToDoItem]]
    enum ViewType {
        
        case edit
    }
    init(todoItems: [[ToDoItem]], viewType: ViewType) {
        self.todoItems = todoItems
        self.viewType = viewType
    }
    
    
}
