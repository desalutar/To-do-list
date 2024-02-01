//
//  TodoEntity+CoreDataProperties.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 01.02.24.
//
//

import Foundation
import CoreData


extension TodoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoEntity> {
        return NSFetchRequest<TodoEntity>(entityName: "TodoEntity")
    }
    
    @NSManaged public var date: Date?
    @NSManaged public var descriptionTask: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: Data?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?
}

extension TodoEntity : Identifiable {

}
