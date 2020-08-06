//
//  ItemProduct.swift
//  WineUpp
//
//  Created by Thaliees on 8/6/20.
//  Copyright © 2020 Thaliees. All rights reserved.
//

import Foundation

// A product can have these (and other) properties. For now, these will serve us for the payment transaction
// We will use the class to create objects that the user will buy
class ItemProduct {
    let id: String
    let name: String
    let image: String
    let productDescription: String
    var quantity: Int
    let unitPrice: Double
    let taxable: Bool
    // A product may have extra charges at its unit price: taxes, duties and shipping.
    let tax: AdditionalAmounts
    let duty: AdditionalAmounts
    let shipping: AdditionalAmounts
    
    init(id: String, name: String, image: String, productDescription: String, quantity: Int, unitPrice: Double, taxable: Bool, tax: AdditionalAmounts, duty: AdditionalAmounts, shipping: AdditionalAmounts) {
        self.id = id
        self.name = name
        self.image = image
        self.productDescription = productDescription
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.taxable = taxable
        self.tax = tax
        self.duty = duty
        self.shipping = shipping
    }
}

extension ItemProduct {
    var totalPay: Double {
        return (Double(self.quantity) * self.unitPrice) + tax.amount + duty.amount + shipping.amount
    }
}
