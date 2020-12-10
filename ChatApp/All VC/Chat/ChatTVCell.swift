//
//  ChatTVCell.swift
//  BunTwo
//
//  Created by Chandresh Kachariya on 08/05/20.
//  Copyright © 2020 Fascinate Infotech. All rights reserved.
//  

import UIKit
import FirebaseStorage
import FirebaseDatabase

class ChatTVCell: UITableViewCell {

    /*************  UIImageView  ************************/
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var imgPhoto: UIImageView!
    
    /*************  UILabel  ************************/
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblTime: UILabel!

    var messageDetail: MessageDetail!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgProfile.layer.roundCorners(cornerRadius: Double(imgProfile.frame.size.height/2))

        lblName.textColor = grayColor
//        lblName.font = getFont(fontName: _font_Montserrat_Medium, fontSize: 17)
        
        lblDesc.textColor = darkGrayColor
        //lblDesc.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 15)
        
        lblTime.textColor = darkGrayColor
        //lblTime.font = getFont(fontName: _font_Montserrat_Medium, fontSize: 15)


    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(messageDetail: MessageDetail) {
        
        self.messageDetail = messageDetail
        self.lblName.text = messageDetail.recipient
        self.lblName.isHidden = false
        self.lblDesc.text = messageDetail.lastMsg
        /*
        let recipientData = Database.database().reference().child("users").child(messageDetail.recipient)
        
        recipientData.observeSingleEvent(of: .value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            
            let username = data["full_name"]
            theAppDelegate?.chatUserName.append(username as! String)
            //let chatPreviewText = (((data["messages"] as! NSDictionary).allValues as! NSArray)[0] as! NSDictionary)["lastmessage"]
            self.lblName.text = username as? String
            //self.chatPreview.text = chatPreviewText as? String
            
            let userImg = data["image"]
            self.imgProfile.getImage(url: BASEIMAGEURL + (userImg as! String), placeholderImage: UIImage.init(named: "profile"), success: { (success) in
                
            }) { (faild) in
                
            }
            
            let dictMessage = (data["messages"] as! NSDictionary).value(forKey: self.messageDetail.messageKey) as! NSDictionary

            let messageVisibility = dictMessage.value(forKey: "messageVisibility") as! String
            if (messageVisibility).contains(String(getDictionary(_key: _key_UserDetails).value(forKey: "id") as! String)) {
                
                let isDeleted = dictMessage.value(forKey: "isDeleted") as! String
                if isDeleted.elementsEqual("true") {
                    self.lblDesc.text = "This Message was deleted"
                }else {
                }
                
                let lastMessageTime = dictMessage.value(forKey: "lastMessageTime") as? String ?? ""
                if lastMessageTime != "" {
                    
                    let strSeenInfo = getLastSeenTodayOrYesterday(messageDate: lastMessageTime.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime())
                    if strSeenInfo.elementsEqual(_str_today) {
                        self.lblTime.text = lastMessageTime.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime().toString(dateFormat: "hh:mm a")
                    }else if strSeenInfo.elementsEqual(_str_yesterday) {
                        self.lblTime.text = _str_yesterday.capitalized
                    }else {
                        self.lblTime.text = lastMessageTime.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime().toString(dateFormat: "MMM dd")
                    }
                    
                }else {
                    self.lblTime.text = lastMessageTime
                }
                print(lastMessageTime.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime())
            }else {
                self.lblDesc.text = ""
                self.lblTime.text = ""
            }
            
        })
         */
    }
}
