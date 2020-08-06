//
//  APIAuthorizeNetManager.swift
//  WineUpp
//
//  Created by Thaliees on 8/6/20
//  Copyright © 2020 Thaliees. All rights reserved.
//

import UIKit
import AEXML

class APIAuthorizeNetManager: NSObject {
    let baseURLTest = "https://apitest.authorize.net/xml/v1/request.api"
    let baseURL = "https://api.authorize.net/xml/v1/request.api"
    static let sharedInstance = APIAuthorizeNetManager()
    
    private var urlSession:URLSession = {
        let newConfiguration:URLSessionConfiguration = .default
        newConfiguration.waitsForConnectivity = false
        newConfiguration.allowsCellularAccess = true
        newConfiguration.timeoutIntervalForRequest = 10
        return URLSession(configuration: newConfiguration)
    }()
    
    func createTransactionProfileRequest(xml document: AEXMLDocument, onSuccess: @escaping (AEXMLDocument) -> Void, onFailure: @escaping (String) -> Void) {
        let url:String = baseURLTest
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = document.xml.data(using: .utf8)
        
        let task = urlSession.dataTask(with: request as URLRequest, completionHandler: { data, response, error -> Void in
            if error != nil {
                onFailure(error!.localizedDescription)
            }
            else {
                let statusResponse = response as! HTTPURLResponse
                switch statusResponse.statusCode {
                    case 200:
                        do {
                            let doc = try AEXMLDocument(xml: data!)
                            onSuccess(doc)
                        } catch let error {
                            onFailure(error.localizedDescription)
                        }
                    
                    default:
                        onFailure("Error Unknow")
                }
            }
        })
        
        task.resume()
    }
}
