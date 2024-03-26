//
//  ToDoItem+Seeds.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 25.03.24.
//

import Foundation

enum ToDoItemTests {
    static let testToDoItem = [
    [
        ToDoItem(
            id: UUID(),
            isCompleted: true,
            title: "foo",
            description: "bar",
            picture: nil,
            date: nil
        )
    ],
    [
        ToDoItem(
            id: UUID(),
            isCompleted: false,
            title: "baz",
            description: "bar",
            picture: nil,
            date: nil
        )]
    ]
    
    static let todoItem = ToDoItem(
        id: UUID(),
        isCompleted: false,
        title: "appended",
        description: "newItem",
        picture: nil,
        date: nil
    )
    
    static let unfulfilledSectionItem = ToDoItem(
        id: UUID(),
        isCompleted: false,
        title: "completed",
        description: "Section",
        picture: nil,
        date: nil
    )
    
    static let completedSectionItem = ToDoItem(
        id: UUID(),
        isCompleted: true,
        title: "unfulfilled",
        description: "Section",
        picture: nil,
        date: nil
    )
}
