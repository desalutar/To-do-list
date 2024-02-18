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
    func makeNotificationWith(title: String, description: String?, date: Date?)
}

final class CreatePresenter: CreatePresentable {
    weak var view: CreateViewControllerProtocol?
    
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
    
    func makeNotificationWith(title: String, description: String?, date: Date?) {
        guard let date else { return }
        let notificationManager = LocalNotificationManager(notificationTitle: title, notificationDescription: description, notificationDate: date)
        notificationManager.createLocalNotification()
    }
}
