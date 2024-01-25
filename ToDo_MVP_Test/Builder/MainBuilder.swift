//
//  MainBuilder.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 21.01.24.
//

import UIKit

protocol MainBuilderProtocol: AnyObject {
    func buildTodoList() -> StartViewController
    func buildCreateVC() -> CreateViewController
}

final class MainBuilder: MainBuilderProtocol {
    
    func buildTodoList() -> StartViewController {
        let presenter = StartPresenter(todoItems: [[]])
        let startVC = StartViewController(presenter: presenter)
        presenter.view = startVC
        return startVC
    }
    
    func buildCreateVC() -> CreateViewController {
        let presenter = CreatePresenter()
        let createVC = CreateViewController(presenter: presenter)
        presenter.view = createVC
        return createVC
        
    }
    
    
    // собрать модальный переход в методе did select row at в класс ячейки
    
}
