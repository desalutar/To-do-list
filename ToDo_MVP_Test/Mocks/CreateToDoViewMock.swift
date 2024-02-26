//
//  CreateToDoViewMock.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 25.02.24.
//

import Foundation

final class CreateToDoViewMock: CreateToDoViewControllerProtocol {
    
    private(set) var didCreateToDoWasTapped = 0
    private(set) var didCreateToDoArgument: ToDoItem?
    
    func didCreateToDo(with item: ToDoItem) {
        didCreateToDoWasTapped += 1
        didCreateToDoArgument = item
    }
}
