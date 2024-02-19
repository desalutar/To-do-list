//
//  CreateViewControllerMock.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 04.02.24.
//

import Foundation

final class CreateViewControllerMock: CreateViewControllerProtocol {
    func presentAlert() { }
    
    
    private(set) var didCreateToDoWasTapped = 0
    var didCreateToDoArgument: ToDoItem?

    func didCreateToDo(with item: ToDoItem) {
        didCreateToDoWasTapped += 1
        didCreateToDoArgument = item
    }
}
