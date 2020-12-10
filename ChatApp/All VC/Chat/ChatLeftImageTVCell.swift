//
//  ChatLeftImageTVCell.swift
//  PDA
//
//  Created by Chandresh Kachariya on 27/08/20.
//  Copyright © 2020 Gobinder. All rights reserved.
//

import UIKit

class ChatLeftImageTVCell: UITableViewCell {

    /*************  UIImageView  ************************/
    @IBOutlet weak var imgProfle: UIImageView!
    @IBOutlet weak var imgMessage: UIImageView!

    /*************  UILabel  ************************/
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    /*************  UIView  ************************/
    @IBOutlet weak var viewContaint: UIView!
    @IBOutlet weak var viewShadow: UIView!

    /*************  UIButton  ************************/
    @IBOutlet weak var btnProfile: UIButton!
    @IBOutlet weak var btnTapImage: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imgProfle.layer.roundCorners(cornerRadius: Double(imgProfle.frame.size.height/2))
        
        lblOnline.backgroundColor = greenColor
        lblOnline.layer.roundBorder(cornerRadius: Double(lblOnline.frame.size.height/2), color: barColor, borderWith: 3)
        
        lblTime.textColor = textLightColor
        //lblTime.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 15)
        
        self.viewContaint.layer.roundCorners(cornerRadius: 12)
        self.viewShadow.layer.roundCorners(cornerRadius: 12)
        self.imgMessage.layer.roundCorners(cornerRadius: 12)
    }

    func setShadow() {
        delay(bySeconds: 0.1) {
            self.viewShadow.dropShadow(color: barColor, opacity: 0.75, offSet: CGSize(width: -1, height: 1), radius: 2, scale: false)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(message: Message) {
        
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
        print(messageTime)
        
        let dictUserDetails: NSDictionary = getDictionary(_key: _key_UserDetails)
        self.imgProfle.getImage(url: BASEIMAGEURL + (dictUserDetails.value(forKey: "image") as? String ?? ""), placeholderImage: UIImage.init(named: "profile"), success: { (success) in
            
            self.imgProfle.contentMode = .scaleAspectFill
        }) { (faild) in

        }
        
        self.imgMessage.getImage(url: message.message, placeholderImage: nil, success: { (success) in
            
            self.imgMessage.contentMode = .scaleAspectFill
            
        }) { (faild) in

        }
        
        self.setShadow()

    }
    
}
