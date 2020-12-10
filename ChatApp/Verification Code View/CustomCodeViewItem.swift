//
//  CustomCodeViewItem.swift
//  SwiftyCodeView
//
//  Created by Artur Mkrtchyan on 6/30/18.
//  Copyright © 2018 arturdev. All rights reserved.
//

import UIKit
import SwiftyCodeView

class CustomCodeItemView: SwiftyCodeItemView {
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var lblBottom: UILabel!
    
    override func awakeFromNib() {
        isUserInteractionEnabled = false
        textField.text = ""
        textField.font = getFont(fontName: _font_Montserrat_Medium, fontSize: 17.5)
        textField.textColor = greyColor
        
        borderView.layer.borderWidth = 0
        borderView.layer.borderColor = UIColor.darkGray.cgColor
    }
}
