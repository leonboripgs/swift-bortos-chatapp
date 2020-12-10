//
//  Helper.swift
//
//  Copyright (c) 2017-Present Jochen Pfeiffer
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

//import JJFloatingActionButton
import UIKit
import StoreKit
//import SwiftKeychainWrapper

internal struct Helper {
//    static func showAlert(for item: JJActionItem) {
//        showAlert(title: item.titleLabel.text, message: "Item tapped!")
//    }

    static func showToastAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        rootViewController?.present(alertController, animated: true, completion: nil)
        delay(bySeconds: 2.0) {
            alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    static func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        rootViewController?.present(alertController, animated: true, completion: nil)
    }

    static var rootViewController: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
    
    static func getBundleIndentifire() -> String {
        return Bundle.main.bundleIdentifier!
    }
    
    static func getAppName() -> String {
        return Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
    }
    
//    static func getUUID() -> String {
//        //Check is uuid present in keychain or not
//        if let deviceId: String = KeychainWrapper.standard.string(forKey: "deviceId") {
//            return deviceId
//        }else{
//            // if uuid is not present then get it and store it into keychain
//            let key : String = (UIDevice.current.identifierForVendor?.uuidString)!
//            let saveSuccessful: Bool = KeychainWrapper.standard.set(key, forKey: "deviceId")
//            print("Save was successful: \(saveSuccessful)")
//            return key
//        }
//    }
    
    static func rating() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()

        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "APP_ID") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    static func share(text: String, image: UIImage, url: String, viewController: UIViewController) {
        let myWebsite = NSURL(string:url)
        let shareAll = [text , image , myWebsite as Any] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    static func share(text: String, url: String, viewController: UIViewController) {
        let myWebsite = NSURL(string:url)
        let shareAll = [text , myWebsite as Any] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
}
