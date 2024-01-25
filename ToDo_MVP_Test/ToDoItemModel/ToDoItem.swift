//
//  ToDoItem.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 20.01.24.
//

import Foundation
import UIKit

struct ToDoItem: Hashable {
    let id: UUID
    let title: String
    let description: String
    var isCompleted: Bool
    var picture: UIImage?
    let date: Date?
    
    init(
        id: UUID = UUID(),
        isCompleted: Bool = false,
        title: String,
        description: String,
        picture: UIImage? = nil,
        date: Date?
    ) {
        self.id = id
        self.isCompleted = isCompleted
        self.title = title
        self.description = description
        self.picture = picture
        self.date = date
    }
}
