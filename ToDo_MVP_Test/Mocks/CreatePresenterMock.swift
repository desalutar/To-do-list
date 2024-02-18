//
//  CreatePresenterMock.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 04.02.24.
//

import Foundation

final class CreatePresenterMock: CreatePresentable {
    
    
    
    private(set) var createToDoWasTapped = 0
    private(set) var createToDoDataArgument: ToDoItemData?
    
    func createToDo(with todoItemData: ToDoItemData) {
        createToDoWasTapped += 1
        createToDoDataArgument = todoItemData
    }
    func makeNotificationWith(title: String, description: String?, date: Date?) {
        //
    }
}
