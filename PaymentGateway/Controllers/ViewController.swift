//
//  ViewController.swift
//  PaymentGateway
//
//  Created by Thaliees on 8/6/20
//  Copyright © 2020 Thaliees. All rights reserved.
//
// For more information about Test Guide (You can found the Test Card Numbers here): https://developer.authorize.net/hello_world/testing_guide/

import UIKit
import AuthorizeNetAccept
import AEXML

class ViewController: UIViewController, UITextFieldDelegate {

    private let kClientName = "5KP3u95bQpv"
    private let kClientTransactionKey = "346HZ32z3fP4hTG2"
    private let kAcceptSDKCreditCardLength:Int = 16
    private let kAcceptSDKCreditCardMaskLength:Int = 19
    private let kAcceptSDKExpirationMonthLength:Int = 2
    private let kAcceptSDKExpirationYearLength:Int = 2
    private let kAcceptSDKCVVLength:Int = 4
    fileprivate var cardNumberBuffer:String! = ""
    private var productList:[ItemProduct] = [ItemProduct]()
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var postalCode: UITextField!
    @IBOutlet weak var cardNumber: UITextField!
    @IBOutlet weak var expirationMonth: UITextField!
    @IBOutlet weak var expirationYear: UITextField!
    @IBOutlet weak var security: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Initialize the product to be paid.
        // As we have preloaded the data in the Storyboard, we will start with that data
        // (Create an ItemProduct class to work)
        let product = ItemProduct(id: "54200283", name: "Product", image: "", productDescription: "Example", quantity: 2, unitPrice: 15, taxable: false,
                                  tax: AdditionalAmounts(name: "Tax", amount: 0.0, additionalDescription: "Tax Description"),
                                  duty: AdditionalAmounts(name: "Duty", amount: 0.0, additionalDescription: "Duty Description"),
                                  shipping: AdditionalAmounts(name: "Shipping", amount: 1.0, additionalDescription: "Shipping Description"))
        // As we can handle several products in a single transaction, we add this product to our product list
        productList.append(product)
    }

    @IBAction func confirmPayment(_ sender: UIButton) {
        if validateForm() {
            let alert = UIAlertController(title: "Save card", message: "Do you want to save the card for next purchases?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                self.createXML(saveCard: false)
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.createXML(saveCard: true)
            }))
            
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func validateForm() -> Bool {
        if !name.isValidText() {
            showAlertError(message: "Name no is valid")
            return false
        }
        
        if !lastName.isValidText() {
            showAlertError(message: "Lastname no is valid")
            return false
        }
        
        if address.text!.isEmpty || address.text == "" {
            showAlertError(message: "Address no is valid")
            return false
        }
        
        if city.text!.isEmpty || city.text == "" {
            showAlertError(message: "City no is valid")
            return false
        }
        
        if !postalCode.isANumber() {
            showAlertError(message: "Postal code no is valid")
            return false
        }
        
        let validator = AcceptSDKCardFieldsValidator()
        if !cardNumber.isANumber(number: cardNumberBuffer!) {
            showAlertError(message: "Card number no is valid")
            return false
        }
        else {
            if !validator.validateCardWithLuhnAlgorithm(cardNumberBuffer) || cardNumber.text!.count < AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardNumberCharacterCountMin {
                showAlertError(message: "Card number no is valid")
                return false
            }
        }
        
        if !expirationMonth.isANumber() {
            showAlertError(message: "Expiration Month no is valid")
            return false
        }
        else {
            let month = Int(expirationMonth.text!)
            
            if month! >= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardExpirationMonthMin && month! <= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardExpirationMonthMax { }
            else {
                showAlertError(message: "Expiration Month no is valid")
                return false
            }
        }
        
        if !expirationYear.isANumber() {
            showAlertError(message: "Expiration year no is valid")
            return false
        }
        else {
            let year = Int(expirationYear.text!)
            
            if year! >= validator.cardExpirationYearMin() && year! <= AcceptSDKCardFieldsValidatorConstants.kInAppSDKCardExpirationYearMax { }
            else {
                showAlertError(message: "Expiration year no is valid")
                return false
            }
        }
        
        if !validator.validateExpirationDate(expirationMonth.text!, inYear: expirationYear.text!) {
            showAlertError(message: "Expiration Date no is valid")
            return false
        }
        
        if !security.isANumber() {
            showAlertError(message: "CVV no is valid")
            return false
        }
        else {
            if !validator.validateSecurityCodeWithString(security.text!){
                showAlertError(message: "CVV no is valid")
                return false
            }
        }
        
        if email.text! != "" {
            if !email.isValidEmail() {
                showAlertError(message: "Email is invalid")
                return false
            }
        }
        
        return true
    }
    
    private func showAlertError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAlert(msg: String) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        let margin:CGFloat = 10.0
        let customView = UIView(frame: CGRect(x: margin, y: margin, width: alert.view.bounds.size.width - margin * 4.0, height: 150))
        customView.backgroundColor = .clear
        
        let check = UIImageView(frame: CGRect(x: 95, y: 0, width: 72, height: 72))
        check.image = UIImage(named: "check_circle")
        customView.addSubview(check)
        
        let title = UILabel(frame: CGRect(x: 30, y: 80, width: 200, height: 60))
        title.font = UIFont.boldSystemFont(ofSize: 25)
        title.text = "Thanks!"
        title.numberOfLines = 2
        title.textAlignment = .center
        customView.addSubview(title)
        
        let message = UILabel(frame: CGRect(x: 5, y: 140, width: 240, height: 60))
        message.font = UIFont.systemFont(ofSize: 16)
        message.text = msg
        message.numberOfLines = 0
        message.textAlignment = .center
        customView.addSubview(message)
        
        alert.view.addSubview(customView)
        
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 260)
        alert.view.addConstraint(height)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func isMaxLength(textField: UITextField) -> Bool {
        if textField == cardNumber && textField.text!.count >= kAcceptSDKCreditCardMaskLength { return true }
        if textField == expirationMonth && textField.text!.count >= kAcceptSDKExpirationMonthLength { return true }
        if textField == expirationYear && textField.text!.count >= kAcceptSDKExpirationYearLength { return true }
        if textField == security && textField.text!.count >= kAcceptSDKCVVLength { return true }
        
        return false
    }
    
    private func formatCardNumber() {
        var value = String()
        
        let length = cardNumberBuffer.count
        for (i, _) in cardNumberBuffer.enumerated() {
            if length <= kAcceptSDKCreditCardLength - 4 {
                if i == length - 1 {
                    let charIndex = cardNumberBuffer.index(cardNumberBuffer.startIndex, offsetBy: i)
                    let tempString = String(cardNumberBuffer.suffix(from: charIndex))
                    value += tempString
                }
                else { value += "*" }
            }
            else {
                if i < kAcceptSDKCreditCardLength - 4 { value += "*" }
                else {
                    let charIndex = cardNumberBuffer.index(cardNumberBuffer.startIndex, offsetBy: i)
                    let tempString = String(cardNumberBuffer.suffix(from: charIndex))
                    value += tempString
                    break
                }
            }
            
            if (i + 1) % 4 == 0 && value.count < kAcceptSDKCreditCardMaskLength {
                value += " "
            }
        }
        
        cardNumber.text = value
    }
    
    private func createXML(saveCard: Bool) {
        let document = TransactionRequest()
        
        let amount = calculateTotal()
        let expiration = expirationDate(year: expirationYear.text!, month: expirationMonth.text!)
        let tax = AdditionalAmounts(name: "Tax", amount: calculateTax(), additionalDescription: "Tax description")
        let duty = AdditionalAmounts(name: "Duty", amount: calculateDuty(), additionalDescription: "Duty description")
        let shipping = AdditionalAmounts(name: "Shipping", amount: calculateShipping(), additionalDescription: "Shipping description")
        let sendEmail = email.text! == "" ? false : true
        
        document.createXML(kClientName: kClientName, kClientTransactionKey: kClientTransactionKey, ref: "Product", transactionType: TransactionTypes.authCaptureTransaction.rawValue, amount: String(amount), cardNumber: cardNumberBuffer, expiration: expiration, cardCode: security.text!, createProfile: saveCard, items: productList, tax: tax, duty: duty, shipping: shipping, order: "000001", typeCustomer: CustomerTypes.individual.rawValue, idDatabase: "1", email: email.text!, name: name.text!, lastName: lastName.text!, address: address.text!, city: city.text!, postalCode: postalCode.text!, settingName: TransactionSettings.emailCustomer.rawValue, settingValue: String(sendEmail))
        // Uncomment to see the structure of the document created
        //print(document.xmlDocument.xml)
        transactionPayment(document: document.xmlDocument)
    }
    
    private func expirationDate(year:String, month:String) -> String {
        let components = Calendar.current.dateComponents([Calendar.Component.year], from: Date())
        let cYear = String(components.year!)
        let sYear = String(cYear.prefix(2)) + year
        
        return "\(sYear)-\(month)"
    }
    
    private func calculateTotal() -> Double {
        var total:Double = 0.0
        for item in productList {
            total += item.totalPay
        }
        
        return total
    }
    
    private func calculateTax() -> Double {
        var tax:Double = 0.0
        for item in productList {
            tax += item.tax.amount
        }
        
        return tax
    }
    
    private func calculateDuty() -> Double {
        var duty:Double = 0.0
        for item in productList {
            duty += item.duty.amount
        }
        
        return duty
    }
    
    private func calculateShipping() -> Double {
        var shipping:Double = 0.0
        for item in productList {
            shipping += item.shipping.amount
        }
        
        return shipping
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardNumber {
            if string.count > 0 {
                if isMaxLength(textField: cardNumber) { return false }
                cardNumberBuffer = String(format: "%@%@", cardNumberBuffer, string)
            }
            else {
                if cardNumberBuffer.count > 1 {
                    let length = cardNumberBuffer.count - 1
                    cardNumberBuffer = String(cardNumberBuffer[cardNumberBuffer.index(cardNumberBuffer.startIndex, offsetBy: 0)...cardNumberBuffer.index(cardNumberBuffer.startIndex, offsetBy: length - 1)])
                }
                else { cardNumberBuffer = "" }
            }
            formatCardNumber()
            return false
        }
        
        if textField == expirationMonth {
            if string.count > 0 {
                return !isMaxLength(textField: expirationMonth)
            }
        }
        
        if textField == expirationYear {
            if string.count > 0 {
                return !isMaxLength(textField: expirationYear)
            }
        }
        
        if textField == security {
            if string.count > 0 {
                return !isMaxLength(textField: security)
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == expirationMonth {
            if textField.text!.count == 1 {
                if textField.text != "0" {
                    textField.text = "0\(textField.text!)"
                }
            }
        }
    }
    
    // MARK: -Authorize.Net
    private func transactionPayment(document: AEXMLDocument) {
        DispatchQueue.main.async {
            APIAuthorizeNetManager.sharedInstance.createTransactionProfileRequest(xml: document, onSuccess: { (response) in
                DispatchQueue.main.async {
                    // Uncomment to see the structure of the document created
                    //print(response.xml)
                    let xmlResponse = TransactionResponse(xmlDocument: response)
                    if xmlResponse.xmlError() {
                        let error = xmlResponse.xmlErrorString()
                        self.showAlertError(message: error)
                    }
                    else {
                        var success = xmlResponse.xmlTransactionSuccessful()
                        // Each card saved is a profile
                        if xmlResponse.isCardSaved() {
                            // The information that returns in the "profileResponse" node is as follows
                            // The idCustomerProfileClient is the identifier of the saved card, and with this id, make future transactions
                            let idCustomerProfile = xmlResponse.getIdCustomerProfileClient()
                            // The idCustomerPayment is the payment identifier
                            let idCustomerPayment = xmlResponse.getIdCustomerPaymentProfileClient()
                            // The idCustomerShipping is the merchant's identifier
                            let idCustomerShipping = xmlResponse.getIdCustomerShippingProfileClient()
                            // This information can be saved
                            success += "\nProfile: \(idCustomerProfile)\nPayment \(idCustomerPayment)\nShipping \(idCustomerShipping)"
                        }
                        
                        self.showAlert(msg: success)
                    }
                }
            }) { (error) in
                DispatchQueue.main.async {
                    self.showAlertError(message: error)
                }
            }
        }
    }
}

