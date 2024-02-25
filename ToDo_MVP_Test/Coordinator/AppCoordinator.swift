//
//  AppCoordinator.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 20.01.24.
//

import Foundation
import UIKit

final class AppCoordinator: CoordinatorProtocol {
    var navigationController: UINavigationController
    var builder: MainBuilderProtocol

    init(navigationController: UINavigationController, builder: MainBuilderProtocol) {
        self.navigationController = navigationController
        self.builder = builder
    }
    
    func showToDoList() {
        let todoListController = builder.buildTodoList()
        todoListController.coordinator = self
        navigationController.pushViewController(todoListController, animated: false)
    }
    
    func showCreateViewController() {
        let createToDoViewController = builder.buildCreateVC()
        createToDoViewController.coordinator = self
        let todoListViewController = navigationController.viewControllers.first as? ToDoListController
        createToDoViewController.delegate = todoListViewController
        
        navigationController.present(createToDoViewController, animated: true)
    }
    
    func showEditViewController(todo: ToDoItem) {
        let editViewController = builder.buildEditVC(todo: todo)
        editViewController.coordinator = self
        let todoListViewController = navigationController.viewControllers.first as? ToDoListController
        editViewController.delegate = todoListViewController
        navigationController.pushViewController(editViewController, animated: true)
    }
    
    func popToListToDoViewController() {
        navigationController.popViewController(animated: true)
    }
    
    func dissmiss() {
        navigationController.topViewController?.dismiss(animated: true)
    }
}
