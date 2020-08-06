//
//  TransactionSettings.swift
//  PaymentGateway
//
//  Created by Thaliees on 12/6/19.
//  Copyright © 2020 Thaliees. All rights reserved.
//
// For more information: https://developer.authorize.net/api/reference/features/payment_transactions.html

import Foundation

enum TransactionSettings: String {
    case emailCustomer = "emailCustomer"
    case headerEmailReceipt = "headerEmailReceipt"
    case footerEmailReceipt = "footerEmailReceipt"
    case allowPartialAuth = "allowPartialAuth"
    case duplicateWindow = "duplicateWindow"
    case recurringBilling = "recurringBilling"
}
