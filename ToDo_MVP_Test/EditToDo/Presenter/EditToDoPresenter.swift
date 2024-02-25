//
//  PresenterEditViewController.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 28.01.24.
//

import Foundation

protocol EditToDoViewControllerPresentable: AnyObject {
    func didEditTodo(with data: ToDoItemData)
    func makeNotificationWith(title: String, description: String?, date: Date?)
}

final class EditToDoPresenter: EditToDoViewControllerPresentable {
    weak var view: EditToDoViewControllerProtocol?
    var todoItem: ToDoItem

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
    
    func makeNotificationWith(title: String, description: String?, date: Date?) {
        guard let date else { return }
        let notificationManager = LocalNotificationManager(notificationTitle: title, notificationDescription: description, notificationDate: date)
        notificationManager.createLocalNotification {
            print(123)
        }
        
    }
}
