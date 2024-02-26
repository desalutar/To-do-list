//
//  EditToDoViewMock.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 26.02.24.
//

import Foundation

final class EditToDoViewMock: EditToDoViewControllerProtocol {

    private(set) var didEditTodoWasTapped = 0
    private(set) var didEditTodoArgument: ToDoItem?
    
    func didEditToDo(with todo: ToDoItem) {
        didEditTodoWasTapped += 1
        didEditTodoArgument = todo
    }
    
    func makeNotificationWith(title: String, description: String?, date: Date?) {
        
    }
}
