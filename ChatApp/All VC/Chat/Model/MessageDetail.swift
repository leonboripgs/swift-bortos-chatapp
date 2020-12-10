//
//  MessageDetail.swift
//  MessageApp
//
//  Created by Kasey Schlaudt on 4/19/17.
//  Copyright © 2017 Kasey Schlaudt. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
import SwiftKeychainWrapper

class MessageDetail {
    
    var date: Date = Date()

    private var _recipient: String!
    
    private var _uuid: String!
    
    private var _lastMsg: String!
    
//    private var _messageKey: String!
    
//    private var _messageRef: DatabaseReference!
    
//    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var recipient: String {
        
        return _recipient
    }
    
    var uuid: String {
        return _uuid
    }
    
    var lastMsg: String {
        return _lastMsg
    }
//    var messageKey: String {
//
//        return _messageKey
//    }
    
//    var messageRef: DatabaseReference {
//
//        return _messageRef
//    }
    
    init(recipient: String) {
        
        _recipient = recipient
    }
    
    init(recipient: String, uuid: String, lastMsg: String) {
        _recipient = recipient
        _uuid = uuid
        _lastMsg = lastMsg
    }
//
//    init(messageKey: String, messageData: Dictionary<String, AnyObject>) {
//
//        _messageKey = messageKey
//
//        if let recipient = messageData["recipient"] as? String {
//
//            _recipient = recipient
//        }
//
//        _messageRef = Database.database().reference().child("recipient").child(_messageKey)
//
//        // Set the date formatter and optionally set the formatted date from string
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        if let date = dateFormatter.date(from: messageData["lastMessageTime"] as? String ?? "") {
//            self.date = date
//        }
//    }
}

















