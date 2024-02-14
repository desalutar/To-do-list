//
//  ViewExtension.swift
//  ToDo_MVP_Test
//
//  Created by Ишхан Багратуни on 14.02.24.
//

import UIKit

extension CreateEditTodoView: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        return false
    }
}
