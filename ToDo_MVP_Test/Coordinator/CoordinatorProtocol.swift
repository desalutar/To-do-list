//
//  CoordinatorProtocol.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 20.01.24.
//

import UIKit

protocol CoordinatorProtocol {
    var navigationController: UINavigationController { get }
    var builder: MainBuilderProtocol { get }
    func showStartScreen()
}
