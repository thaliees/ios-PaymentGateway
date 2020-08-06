//
//  UITextFieldExtension.swift
//  PaymentGateway
//
//  Created by Thaliees on 8/6/20
//  Copyright © 2020 Thaliees. All rights reserved.
//

import UIKit

extension UITextField {
    func isValidEmail() -> Bool {
        let REGEX_EMAIL = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", REGEX_EMAIL)
        return emailPred.evaluate(with: text?.trimmingCharacters(in: .whitespaces))
    }
    
    func isANumber() -> Bool {
        let REGEX_PHONE = "^[0-9]+$"
        let numberPred = NSPredicate(format: "SELF MATCHES %@", REGEX_PHONE)
        return numberPred.evaluate(with: text?.trimmingCharacters(in: .whitespaces))
    }
    
    func isANumber(number: String) -> Bool {
        let REGEX_PHONE = "^[0-9]+$"
        let numberPred = NSPredicate(format: "SELF MATCHES %@", REGEX_PHONE)
        return numberPred.evaluate(with: number.trimmingCharacters(in: .whitespaces))
    }
    
    func isValidText() -> Bool {
        let REGEX_TEXT = "^[a-zA-ZáÁéÉíÍóÓúÚñÑüÜ\\s]+$"
        let textPred = NSPredicate(format: "SELF MATCHES %@", REGEX_TEXT)
        return textPred.evaluate(with: text?.trimmingCharacters(in: .whitespaces))
    }
}
