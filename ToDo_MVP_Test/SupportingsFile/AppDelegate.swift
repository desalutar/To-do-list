//
//  AppDelegate.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 20.01.24.
//

import UIKit
import CoreData
import UserNotifications

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
                print(settings)
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
                
        sendNotifications()
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataManager.shared.saveContext()
    }
    
    func sendNotifications() {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body = "Body"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
        notification.add(request)
    }

}

