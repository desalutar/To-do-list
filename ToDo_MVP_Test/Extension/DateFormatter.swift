//
//  DateFormatter.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 24.01.24.
//

import Foundation

extension Date {
    var stringValue: String? {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.locale = Locale(identifier: "ru_RU")
        
        return formatter.string(from: self)
    }
}
