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
        let mainViewController = builder.buildTodoList()
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: false)
    }
    
    func showCreateViewController() {
        let createViewController = builder.buildCreateVC()
        createViewController.coordinator = self
        let todoListViewController = navigationController.viewControllers.first as? ToDoListController
        createViewController.delegate = todoListViewController
        
        navigationController.present(createViewController, animated: true)
    }
    
    func showEditViewController(todo: ToDoItem) {
        let editViewController = builder.buildEditVC(todo: todo)
        editViewController.coordinator = self
        let todoListViewController = navigationController.viewControllers.first as? ToDoListController
        editViewController.delegate = todoListViewController
        navigationController.pushViewController(editViewController, animated: true)
    }
    
    func popToRootVC() {
        navigationController.popViewController(animated: true)
    }
    
    func dissmiss() {
        navigationController.topViewController?.dismiss(animated: true)
    }
}
