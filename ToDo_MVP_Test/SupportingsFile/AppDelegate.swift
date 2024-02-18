//
//  AppDelegate.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 20.01.24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?
    let notification = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notification.requestAuthorization(options: [.alert, .badge, .sound]) { [ weak self] granted, error in
            guard let self = self,
                       granted else { return }
            self.notification.getNotificationSettings { settings in
                guard settings.authorizationStatus == .authorized else { return }
            }
        }
        
        let navigationController = UINavigationController()
        let builder = MainBuilder()
        coordinator = AppCoordinator(navigationController: navigationController, builder: builder)
        coordinator?.showToDoList()
         
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
}

