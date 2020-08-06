//
//  TransactionTypes.swift
//  PaymentGateway
//
//  Created by Thaliees on 12/6/19.
//  Copyright © 2020 Thaliees. All rights reserved.
//
// For more information: https://developer.authorize.net/api/reference/features/payment_transactions.html

import Foundation

enum TransactionTypes: String {
    case authCaptureTransaction = "authCaptureTransaction"
    case authOnlyTransaction = "authOnlyTransaction"
    case priorAuthCaptureTransaction = "priorAuthCaptureTransaction"
    case captureOnlyTransaction = "captureOnlyTransaction"
    case voidTransaction = "voidTransaction"
    case refundTransaction = "refundTransaction"
}
