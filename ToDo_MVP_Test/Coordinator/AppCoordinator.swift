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
    
    func showStartScreen() {
        let mainViewController = builder.buildTodoList()
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: false)
    }
    
    func showCreateViewController() {
        let createViewController = builder.buildCreateVC()
        createViewController.coordinator = self
        navigationController.present(createViewController, animated: true)
    }
    
    // отправить модальный переход в методе did select row at в класс ячейки
}
