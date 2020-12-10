//
//  Message.swift
//  MessageApp
//
//  Created by Kasey Schlaudt on 4/29/17.
//  Copyright © 2017 Kasey Schlaudt. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class Message {
    
    private var _message: String!
    private var _messageTime: String!
    private var _messageType: String!
    private var _fileName: String!

    private var _from: String!
    private var _to: String!
    
    private var _isDeleted: Bool!
    private var _messageVisibility: String!
    
    private var _messageKey: String!
    
//    var currentUser = KeychainWrapper.standard.string(forKey: "uid")
    
    var message: String {
        
        return _message
    }
    
    var from: String {
        
        return _from
    }
    
    var to: String {
        
        return _to
    }
    
    var messageKey: String{
    
        return _messageKey
    }
    
    var messageTime: String{
    
        return _messageTime
    }
        
    var fileName: String{
    
        return _fileName
    }
        
    var isDeleted: Bool{
    
        return _isDeleted
    }
    
    init(message: String, from: String, to: String, messageTime: String, isDeleted: Bool) {
        
        _message = message
        
        _from = from

        _to = to
        
        _messageTime = messageTime
        
        _isDeleted = isDeleted
        
    }
    /*
    init(messageKey: String, postData: Dictionary<String, AnyObject>) {
        
        _messageKey = messageKey
        
        if let message = postData["message"] as? String {
            
            _message = message
        }
        
        if let sender = postData["sender"] as? String {
            
            _sender = sender
        }
        
        if let messageTime = postData["messageTime"] as? String {
            
            _messageTime = messageTime
        }
        
        if let messageType = postData["messageType"] as? String {
            
            _messageType = messageType
        }
        
        if let fileName = postData["fileName"] as? String {
            
            _fileName = fileName
        }
        
        if let messageVisibility = postData["messageVisibility"] as? String {
            
            _messageVisibility = messageVisibility
        }
        
        if let isDeleted = postData["isDeleted"] as? String {
            
            _isDeleted = isDeleted
        }
        
        //_messageRef = Database.database().reference().child("messages").child(_messageKey) 
    }
 */
}










