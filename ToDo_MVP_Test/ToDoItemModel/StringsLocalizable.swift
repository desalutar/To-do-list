//
//  StringsLocalizable.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 31.01.24.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(
            self,
            comment: "\(self) could not be found in localizable.strings"
        )
    }
}
