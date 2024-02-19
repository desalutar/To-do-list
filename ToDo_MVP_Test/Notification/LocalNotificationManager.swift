//
//  UserNotificationManger.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 02.02.24.
//

import UIKit
import UserNotifications

final class LocalNotificationManager {
    private let notificationTitle: String
    private let notificationDescription: String?
    private let notificationDate: Date
    
    let notification = UNUserNotificationCenter.current()
    
    init(notificationTitle: String, notificationDescription: String?, notificationDate: Date) {
        self.notificationTitle = notificationTitle
        self.notificationDescription = notificationDescription
        self.notificationDate = notificationDate
        notification.requestAuthorization(options: [.alert, .sound]) { permissionGranted, error in }
    }
    
    func createLocalNotification(deniedStatusAction: @escaping () -> Void) {
        notification.getNotificationSettings { settings in
            if settings.authorizationStatus == .denied {
                DispatchQueue.main.async {
                    deniedStatusAction()
                }
            } else {
                self.setDateForNotification()
            }
        }
    }
    private func setDateForNotification() {
        let content = UNMutableNotificationContent()
        content.title = self.notificationTitle
        content.body = self.notificationDescription ?? .empty
        content.sound = .default
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: self.notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        self.notification.add(request)
    }
}
