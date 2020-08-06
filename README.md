# Payment Gateway
[Project created with Xcode V11.2.1] [Deployment Target >= 13.0]     

## Documentation
* [Authorize.Net](https://developer.authorize.net/api/reference/features/in-app.html)
* [Authorize.Net - API Reference](https://developer.authorize.net/api/reference/index.html)

## Prerequisites
1. Register Authorize.Net Account [Register Here](https://sandbox.authorize.net/)

## Getting Started
1. Authorize.Net Developer Sandbox Account: [Link](https://sandbox.authorize.net/)     
    1. Credentials     
        Log in in to your Authorize.Net Developer Sandbox Account. Click on **Account** and in the section **Security Settings**.     
        * Click on *Manage Public Client Key*, and Create a New Public Client Key (click on *Submit*).
        * Click on *API Credentials & Keys*, and Create a New Key, select *New Transaction Key* then click on *Submit*. Copy the API Login ID and Transaction Key. **IMPORTANT:** Be sure to record your Transaction Key immediately in a secure manner or copy it immediately to a file in a secure location as it is not always visible in the Merchant Interface like the API Login ID.
        * To test your Authentication Credentials, enter to [here](https://developer.authorize.net/api/reference/index.html) and in the section **Test Your Authentication Credentials** enter your Sandbox Credentials copied.
2. Install CocoaPods and Pods AuthorizeNetAccept & AEXML     
    * If you don't have cocoapods installed:     
        ```
        % sudo gem install cocoapods
        ```     
    1. Create Podfile within of your project     
        ```
        % pod init
        ```     
    2. Add Pods in your Podfile file created     
        `pod 'AuthorizeNetAccept'`     
        `pod 'AEXML'`     
    3. Install Pods     
    ```
    % pod install
    ```

## Project Base.
The Authorize.Net API is not REST, so it requires the request structure to be identical to that of the .xsd. Below are the classes created so that requests are possible to perform.

- TransactionRequest.swift: To create an XML Request
- TransactionResponse.swift: To create an XML Response
- APIAuthorizeNetManager.swift: To handle Authorize.Net requests