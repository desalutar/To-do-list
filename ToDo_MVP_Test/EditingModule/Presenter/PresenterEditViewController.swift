//
//  PresenterEditViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 28.01.24.
//

import Foundation

protocol EditViewControllerPresentable: AnyObject {
    func configureToDo(with item: ToDoItem)
}

final class EditPresenter: EditViewControllerPresentable {
    weak var view: EditViewController?
    var todoItem: ToDoItem

    init(todoItem: ToDoItem) {
        self.todoItem = todoItem
    }
    
    func configureToDo(with item: ToDoItem) {
        view?.todoImageView.image = item.picture
        view?.titleTextField.text = item.title
        view?.descriptionTextView.text = item.description
        view?.datePickerLabel.text = item.date?.stringValue
    }
}
