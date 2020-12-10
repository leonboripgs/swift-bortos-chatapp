//
//  ChatRightTextTVCell.swift
//  BunTwo
//
//  Created by Chandresh Kachariya on 09/05/20.
//  Copyright © 2020 Fascinate Infotech. All rights reserved.
//

import UIKit

class ChatRightTextTVCell: UITableViewCell {

    /*************  UIImageView  ************************/
    @IBOutlet weak var imgProfle: UIImageView!
    
    /*************  UILabel  ************************/
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    /*************  UILabel  ************************/
    @IBOutlet weak var viewContaint: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgProfle.layer.roundCorners(cornerRadius: Double(imgProfle.frame.size.height/2))
        
        lblOnline.backgroundColor = greenColor
        lblOnline.layer.roundBorder(cornerRadius: Double(lblOnline.frame.size.height/2), color: barColor, borderWith: 3)

        lblMessage.textColor = grayColor
        //lblMessage.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 15)
        
        lblTime.textColor = textLightColor
        //lblTime.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 15)
        
        self.viewContaint.backgroundColor = rightCellColor
        self.viewContaint.layer.roundCorners(cornerRadius: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(message: Message) {
        
        if (!message.isDeleted){
            self.lblMessage.text = message.message
        }else {
            self.lblMessage.text = "This Message was deleted"
        }
        
        let messageTime = message.messageTime
        if messageTime != "" {
            self.lblTime.text = messageTime.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime().toString(dateFormat: "hh:mm a")
            
            let strSeenInfo = getLastSeenTodayOrYesterday(messageDate: (messageTime).toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime())
            
            if strSeenInfo.elementsEqual(_str_today) {
                self.lblTime.text = messageTime.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime().toString(dateFormat: "hh:mm a")
            }else if strSeenInfo.elementsEqual(_str_yesterday) {
                self.lblTime.text = "Yesterday " + (messageTime).toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime().toString(dateFormat: "hh:mm a")
            }else {
                self.lblTime.text = (messageTime).toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime().toString(dateFormat: "MMM dd, yyyy")
                    + " " +
                    messageTime.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime().toString(dateFormat: "hh:mm a")
            }
        }else {
            self.lblTime.text = messageTime
        }
        
        let dictUserDetails: NSDictionary = getDictionary(_key: _key_UserDetails)
        self.imgProfle.getImage(url: BASEIMAGEURL + (dictUserDetails.value(forKey: "image") as? String ?? ""), placeholderImage: UIImage.init(named: "profile"), success: { (success) in
            
            self.imgProfle.contentMode = .scaleAspectFill
        }) { (faild) in

        }
    }
}
