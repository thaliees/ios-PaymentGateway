//
//  TransactionResponse.swift
//  PaymentGateway
//
//  Created by Thaliees on 8/6/20
//  Copyright © 2020 Thaliees. All rights reserved.
//

import Foundation
import AEXML

class TransactionResponse {
    let Error = "Error"
    let RootDocument = "createTransactionResponse"
    let RootDocumentError = "ErrorResponse"
    
    let NodeMessages = "messages"
    let ResultCode = "resultCode"
    let Message = "message"
    let Code = "code"
    let Text = "text"
    let Description = "description"
    let NodeTransactionResponse = "transactionResponse"
    let Errors = "errors"
    let Error_ = "error"
    let ErrorText = "errorText"
    let NodeProfileResponse = "profileResponse"
    
    let CustomerProfile = "customerProfileId"
    let CustomerPayment = "customerPaymentProfileIdList"
    let CustomerShipping = "customerShippingAddressIdList"
    let Numeric = "numericString"
    
    let xmlDocument: AEXMLDocument
    var profile: Bool = true
    
    init(xmlDocument: AEXMLDocument) {
        self.xmlDocument = xmlDocument
    }
    
    func xmlError() -> Bool {
        let result = xmlDocument[RootDocumentError][NodeMessages][ResultCode].value
        return result == Error
    }
    
    func isCardSaved() -> Bool {
        return self.profile
    }
    
    func xmlErrorString() -> String {
        if xmlDocument.root.name == RootDocumentError {
            let codeError = xmlDocument[RootDocumentError][NodeMessages][Message][Code].value!
            let textError = xmlDocument[RootDocumentError][NodeMessages][Message][Text].value!
            return codeError + "\n" + textError
        }
        
        return xmlDocument[RootDocument][NodeTransactionResponse][Errors][Error_][ErrorText].value!
    }
    
    func xmlTransactionSuccessful() -> String {
        let success = xmlDocument[RootDocument][NodeTransactionResponse][NodeMessages][Message][Description].value!
        
        if let profile = xmlDocument[RootDocument][NodeProfileResponse][NodeMessages][ResultCode].value {
            if profile == Error {
                let message = xmlDocument[RootDocument][NodeProfileResponse][NodeMessages][Message][Text].value!
                self.profile = false
                return success + " but " + message
            }
        }
        else { self.profile = false }
        
        return success
    }
    
    func getIdCustomerProfileClient() -> String {
        return xmlDocument[RootDocument][NodeProfileResponse][CustomerProfile].value!
    }
    
    func getIdCustomerPaymentProfileClient() -> String {
        return xmlDocument[RootDocument][NodeProfileResponse][CustomerPayment][Numeric].value!
    }
    
    func getIdCustomerShippingProfileClient() -> String {
        return xmlDocument[RootDocument][NodeProfileResponse][CustomerShipping][Numeric].value!
    }
}
