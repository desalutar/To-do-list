//
//  CoreDataManager.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 01.02.24.
//

import Foundation

import CoreData

// final class CoreDataManager
class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { description, error in
            if let error {
                print(error.localizedDescription)
            } else {
                print("All works - ", description.url ?? [])
            }
        }
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func save(todoItem: ToDoItem) {
        let todoEntity = TodoEntity(context: viewContext)
        todoEntity.id = todoItem.id
        todoEntity.title = todoItem.title
        todoEntity.descriptionTask = todoItem.description
        todoEntity.date = todoItem.date
        todoEntity.image = todoItem.imageData
        todoEntity.isCompleted = todoItem.isCompleted
        
        saveContext()
    }
    
    func fetchAllTodos() -> [[ToDoItem]] {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        var allTodoItems = [[ToDoItem]]()
        do {
            let todos = try viewContext.fetch(fetchRequest)
            let todoItems = todos.map {
                ToDoItem(id: $0.id!,
                         isCompleted: $0.isCompleted,
                         title: $0.title ?? .empty,
                         description: $0.descriptionTask ?? .empty,
                         picture: $0.image,
                         date: $0.date)
            }
            
            let completedTodos = todoItems.filter { $0.isCompleted }
            let unCompleted = todoItems.filter { !$0.isCompleted }
            
            allTodoItems.append(unCompleted)
            allTodoItems.append(completedTodos)
            
        } catch {
            print("error in featureAllTodos ")
        }
        
        return allTodoItems
    }
    
    func update(todoItem: ToDoItem) {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", todoItem.id as CVarArg)
        do {
            guard let entity = try viewContext.fetch(fetchRequest).first else { return }
            entity.isCompleted = todoItem.isCompleted
            saveContext()
        } catch {
            print("error update(todoItem: ToDoItem)")
        }
    }
    
    func swipeDeletion(todoItem: ToDoItem) {
        let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "id", todoItem.id as CVarArg)
        
        do {
            guard let entity = try viewContext.fetch(fetchRequest).first else { return }
            viewContext.delete(entity)
            saveContext()
        } catch {
            print("error in delete(todoItem: )")
        }
    }
}
