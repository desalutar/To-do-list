//
//  UserNotificationManger.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 02.02.24.
//

import UIKit
import UserNotifications

final class LocalNotificationManager: UIViewController {
    private let notificationTitle: String
    private let notificationDescription: String?
    private let notificationDate: Date
    
    let notification = UNUserNotificationCenter.current()
    
    init(notificationTitle: String, notificationDescription: String?, notificationDate: Date) {
        self.notificationTitle = notificationTitle
        self.notificationDescription = notificationDescription
        self.notificationDate = notificationDate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLocalNotification() {
        notification.getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                self.showNotificationSettings()
            } else {
                self.setDateForNotification()
            }
        }
    }
    
    fileprivate func setDateForNotification() {
        let content = UNMutableNotificationContent()
        content.title = self.notificationTitle
        content.body = self.notificationDescription ?? .empty
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notification.add(request) { error in
            if error != nil {
                print("Error" + error.debugDescription)
                return
            }
        }
    }
    
    fileprivate func showNotificationSettings() {
        let alertController = UIAlertController(title: "Enable Notifications?".localized,
                                                message:  "To use this feature you must enable notifications in settings".localized, 
                                                preferredStyle: .alert)
        let goToSettings = UIAlertAction(title: "Settings".localized, style: .default) { _ in
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(settingsURL) {
                UIApplication.shared.open(settingsURL)
            }
        }
        alertController.addAction(goToSettings)
        alertController.addAction(UIAlertAction(title: "Cancel".localized, style: .default))
        self.present(alertController, animated: true)
    }
}
