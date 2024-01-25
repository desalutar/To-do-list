//
//  AppDelegate.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 20.01.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        let builder = MainBuilder()
        coordinator = AppCoordinator(navigationController: navigationController, builder: builder)
        coordinator?.showStartScreen()
         
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
                
        return true
    }
}

