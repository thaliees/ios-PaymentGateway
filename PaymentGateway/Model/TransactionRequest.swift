//
//  TransactionRequest.swift
//  PaymentGateway
//
//  Created by Thaliees on 8/6/20
//  Copyright © 2020 Thaliees. All rights reserved.
//
// For more information: https://developer.authorize.net/api/reference/index.html#payment-transactions
// Schema XML: https://api.authorize.net/xml/v1/schema/AnetApiSchema.xsd

import Foundation
import AEXML

class TransactionRequest {
    let RootDocument = "createTransactionRequest"
    let Attributtes = ["xmlns" : "AnetApi/xml/v1/schema/AnetApiSchema.xsd"]
    // Merchant Node Data
    let Merchant = "merchantAuthentication", Name = "name", MerchantKey = "transactionKey"
    // Reference Node Data
    let RefId = "refId"
    // Transaction Node Data
    let Transaction = "transactionRequest"
    let TransactionType = "transactionType", Amount = "amount"
    // Payment Node Data
    let Payment = "payment", CreditCard = "creditCard", CardNumber = "cardNumber", ExpirationDate = "expirationDate", CardCode = "cardCode"
    // Profile Node Data (Save card)
    let Profile = "profile", CreateProfile = "createProfile"
    // Line Items Node Data (Products)
    let LineItems = "lineItems"
    let LineItem = "lineItem", ItemId = "itemId", Description = "description", ItemQuantity = "quantity", ItemUnitPrice = "unitPrice", ItemTaxable = "taxable"
    // Tax, Duty and Shipping Node Data
    let Tax = "tax", Duty = "duty", Shipping = "shipping"
    // Order Number Node Data
    let PoNumber = "poNumber"
    // Customer Node Data (Only if card data is saved)
    let Customer = "customer", CustomerType = "type", Id = "id", Email = "email"
    // Bill To | Ship To Node Data
    let BillTo = "billTo"
    let ShipTo = "shipTo"
    let FirstName = "firstName", LastName = "lastName", Company = "company", Address = "address", City = "city", Country = "country", Zip = "zip"
    // Transaction Settings Node Data
    let TransactionSettings = "transactionSettings", Setting = "setting", SettingName = "settingName", SettingValue = "settingValue"
    
    let xmlDocument: AEXMLDocument
    
    init() {
        self.xmlDocument = AEXMLDocument()
    }
    
    func createXML(kClientName: String, kClientTransactionKey: String, ref: String, transactionType: String, amount: String, cardNumber: String, expiration: String, cardCode: String, createProfile: Bool, items: [ItemProduct], tax: AdditionalAmounts, duty: AdditionalAmounts, shipping: AdditionalAmounts, order: String, typeCustomer: String, idDatabase: String, email:String, name: String, lastName: String, address: String, city: String, postalCode: String, settingName: String, settingValue: String) {
        let root = AEXMLElement(name: RootDocument, value: nil, attributes: Attributtes)
        
        // Node Required
        // kClientName and kClienTransactionKey are provided in the Merchant Interface and must be stored securely.
        // The keys used in this example are those provided by the API.
        let nodeMerchant = AEXMLElement(name: Merchant)
        nodeMerchant.addChild(AEXMLElement(name: Name, value: kClientName, attributes: [:]))
        nodeMerchant.addChild(AEXMLElement(name: MerchantKey, value: kClientTransactionKey, attributes: [:]))
        root.addChild(nodeMerchant)
        
        // Node Optional
        let nodeRef = AEXMLElement(name: RefId, value: ref, attributes: [:])
        root.addChild(nodeRef)
        
        // Node Required
        let nodeTransaction = AEXMLElement(name: Transaction)
        nodeTransaction.addChild(AEXMLElement(name: TransactionType, value: transactionType, attributes: [:]))
        nodeTransaction.addChild(AEXMLElement(name: Amount, value: amount, attributes: [:]))
        
        // Node Required
        let nodePayment = AEXMLElement(name: Payment)
        let nodeCredit = AEXMLElement(name: CreditCard)
        nodeCredit.addChild(AEXMLElement(name: CardNumber, value: cardNumber, attributes: [:]))
        nodeCredit.addChild(AEXMLElement(name: ExpirationDate, value: expiration, attributes: [:]))
        nodeCredit.addChild(AEXMLElement(name: CardCode, value: cardCode, attributes: [:]))
        nodePayment.addChild(nodeCredit)
        nodeTransaction.addChild(nodePayment)
        
        // Node Optional
        if createProfile {
            let nodeProfile = AEXMLElement(name: Profile)
            nodeProfile.addChild(AEXMLElement(name: CreateProfile, value: String(createProfile), attributes: [:]))
            nodeTransaction.addChild(nodeProfile)
        }
        
        // Node Optional
        let nodeLine = AEXMLElement(name: LineItems)
        let items = createLineItems(items: items)
        nodeLine.addChildren(items)
        nodeTransaction.addChild(nodeLine)
        
        // Node Optional
        let nodeTax = AEXMLElement(name: Tax)
        nodeTax.addChild(AEXMLElement(name: Amount, value: String(tax.amount), attributes: [:]))
        nodeTax.addChild(AEXMLElement(name: Name, value: tax.name, attributes: [:]))
        nodeTax.addChild(AEXMLElement(name: Description, value: tax.additionalDescription, attributes: [:]))
        nodeTransaction.addChild(nodeTax)
        
        // Node Optional
        let nodeDuty = AEXMLElement(name: Duty)
        nodeDuty.addChild(AEXMLElement(name: Amount, value: String(duty.amount), attributes: [:]))
        nodeDuty.addChild(AEXMLElement(name: Name, value: duty.name, attributes: [:]))
        nodeDuty.addChild(AEXMLElement(name: Description, value: duty.additionalDescription, attributes: [:]))
        nodeTransaction.addChild(nodeDuty)
        
        // Node Optional
        let nodeShipping = AEXMLElement(name: Shipping)
        nodeShipping.addChild(AEXMLElement(name: Amount, value: String(shipping.amount), attributes: [:]))
        nodeShipping.addChild(AEXMLElement(name: Name, value: shipping.name, attributes: [:]))
        nodeShipping.addChild(AEXMLElement(name: Description, value: shipping.additionalDescription, attributes: [:]))
        nodeTransaction.addChild(nodeShipping)
        
        // Node Optional
        nodeTransaction.addChild(AEXMLElement(name: PoNumber, value: order, attributes: [:]))
        
        // Node Conditional
        // It exists if you save the card information or if you send a receipt to the customer
        if createProfile {
            let nodeCustomer = AEXMLElement(name: Customer)
            nodeCustomer.addChild(AEXMLElement(name: CustomerType, value: typeCustomer, attributes: [:]))
            // The following two elements are optional.
            // If you have saved the user in your database, for example, you can associate this profile with the identifier you assigned
            nodeCustomer.addChild(AEXMLElement(name: Id, value: idDatabase, attributes: [:]))
            // If you want to associate an email with this profile
            nodeCustomer.addChild(AEXMLElement(name: Email, value: email, attributes: [:]))
            nodeTransaction.addChild(nodeCustomer)
        }
        else if email != "" {
            let nodeCustomer = AEXMLElement(name: Customer)
            nodeCustomer.addChild(AEXMLElement(name: Email, value: email, attributes: [:]))
            nodeTransaction.addChild(nodeCustomer)
        }
        
        // Node Conditional | Optional
        // If you save the card, this node will make the data association
        // If you send a receipt to the user's email, this information also appears on the receipt
        // Therefore, it may exist or not
        let nodeBill = AEXMLElement(name: BillTo)
        nodeBill.addChild(AEXMLElement(name: FirstName, value: name, attributes: [:]))
        nodeBill.addChild(AEXMLElement(name: LastName, value: lastName, attributes: [:]))
        nodeBill.addChild(AEXMLElement(name: Address, value: address, attributes: [:]))
        nodeBill.addChild(AEXMLElement(name: City, value: city, attributes: [:]))
        nodeBill.addChild(AEXMLElement(name: Zip, value: postalCode, attributes: [:]))
        nodeTransaction.addChild(nodeBill)
        
        // Node Optional
        // If you send a receipt to the user's email, this information also appears on the receipt
        // Therefore, it may exist or not
        let nodeShip = AEXMLElement(name: ShipTo)
        nodeShip.addChild(AEXMLElement(name: FirstName, value: "Name", attributes: [:]))
        nodeShip.addChild(AEXMLElement(name: LastName, value: "Last Name", attributes: [:]))
        nodeShip.addChild(AEXMLElement(name: Company, value: "Example", attributes: [:]))
        nodeShip.addChild(AEXMLElement(name: Address, value: "38 1st Ave C", attributes: [:]))
        nodeShip.addChild(AEXMLElement(name: City, value: "Seattle", attributes: [:]))
        nodeShip.addChild(AEXMLElement(name: Zip, value: "98134", attributes: [:]))
        nodeShip.addChild(AEXMLElement(name: Country, value: "USA", attributes: [:]))
        nodeTransaction.addChild(nodeShip)
        
        // Node Optional
        // This node can modify established merchant settings for only the current transaction.
        // In this example, send a receipt to the customer's mail (if the merchant does not have it configured to send automatically, this option is ideal)
        // Therefore, it may exist or not
        let nodeSettings = AEXMLElement(name: TransactionSettings)
        let setting = AEXMLElement(name: Setting)
        setting.addChild(AEXMLElement(name: SettingName, value: settingName, attributes: [:]))
        setting.addChild(AEXMLElement(name: SettingValue, value: settingValue, attributes: [:]))
        nodeSettings.addChild(setting)
        nodeTransaction.addChild(nodeSettings)
        
        root.addChild(nodeTransaction)
        self.xmlDocument.addChild(root)
    }
    
    func createLineItems(items: [ItemProduct]) -> [AEXMLElement] {
        var lineItems = [AEXMLElement]()
        
        for item in items {
            let nodeItem = AEXMLElement(name: LineItem)
            nodeItem.addChild(AEXMLElement(name: ItemId, value: item.id, attributes: [:]))
            nodeItem.addChild(AEXMLElement(name: Name, value: item.name, attributes: [:]))
            nodeItem.addChild(AEXMLElement(name: Description, value: item.productDescription, attributes: [:]))
            nodeItem.addChild(AEXMLElement(name: ItemQuantity, value: String(item.quantity), attributes: [:]))
            nodeItem.addChild(AEXMLElement(name: ItemUnitPrice, value: String(item.unitPrice), attributes: [:]))
            nodeItem.addChild(AEXMLElement(name: ItemTaxable, value: String(item.taxable), attributes: [:]))
            lineItems.append(nodeItem)
        }
        
        return lineItems
    }
}
