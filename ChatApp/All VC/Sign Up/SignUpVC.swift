//
//  SignUpVC.swift
//  ChatApp
//
//  Created by Chandresh Kachariya on 09/09/20.
//  Copyright © 2020 Fascinate Infotech. All rights reserved.
//

import UIKit
import DropDown

import Firebase
import FirebaseDatabase
import FirebaseStorage

class SignUpVC: UIViewController, UITextViewDelegate {

    var isEdit = false
    var mobileNumber:String?
    
    private let kURLSIGNIN = "https://SIGN.IN.com"

    /*************  TextField  ************************/
    @IBOutlet weak var txtFullName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtAlreadySignUp: UITextView!

    /*************  UILabel  ************************/
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSelectAge: UILabel!
    @IBOutlet weak var lblSelectGender: UILabel!
    
    /*************  UILabel  ************************/
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnSelectAge: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnOther: UIButton!
    
    /*************  UIView  ************************/
    @IBOutlet weak var viewFullName: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var viewSelectAge: UIView!
    @IBOutlet weak var viewSelectGender: UIView!
    @IBOutlet weak var viewSelectOther: UIView!
    
    /*************  NSLayoutConstraint  ************************/
    @IBOutlet weak var lblSelectAgeTopConstraint: NSLayoutConstraint!//24 or -42
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initSetup()
        
        if isEdit {
            btnSignUp.setTitle("Update Profile", for: .normal)
            txtAlreadySignUp.isHidden = true
        }else {
            btnSignUp.setTitle("Sign Up", for: .normal)
            txtAlreadySignUp.isHidden = false
        }
    }
    
    func initSetup() {
        
        viewFullName.layer.roundCorners(cornerRadius: Double(self.viewFullName.frame.size.height/2))
        viewEmail.layer.roundCorners(cornerRadius: Double(self.viewEmail.frame.size.height/2))
        viewPassword.layer.roundCorners(cornerRadius: Double(self.viewPassword.frame.size.height/2))
        viewSelectAge.layer.roundCorners(cornerRadius: Double(self.viewSelectAge.frame.size.height/2))
        viewSelectGender.layer.roundCorners(cornerRadius: Double(self.viewSelectGender.frame.size.height/2))
        viewSelectOther.layer.roundCorners(cornerRadius: Double(self.viewSelectOther.frame.size.height/2))
        
        lblTitle.textColor = whiteColor
        lblTitle.font = getFont(fontName: _font_Montserrat_Medium, fontSize: 17)
        
        lblSelectAge.textColor = whiteColor
        lblSelectAge.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 17)
        
        lblSelectGender.textColor = whiteColor
        lblSelectGender.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 17)

        txtFullName.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 17)
        txtFullName.attributedPlaceholder = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor: greyColor])
        
        txtEmail.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 17)
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: greyColor])
        
        txtPassword.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 17)
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: greyColor])

        btnSignUp.setTitleColor(whiteColor, for: UIControl.State.normal)
        btnSignUp.layer.roundBorder(cornerRadius: 26, color: redColor, borderWith: 1.0)
        btnSignUp.backgroundColor = redColor
        btnSignUp.titleLabel?.font = getFont(fontName: _font_Montserrat_SemiBold, fontSize: 20)
        
        btnSelectAge.titleLabel?.font = getFont(fontName: _font_Montserrat_SemiBold, fontSize: 17)
        btnSelectAge.setTitleColor(greyColor, for: .normal)
        
        btnFemale.titleLabel?.font = getFont(fontName: _font_Montserrat_SemiBold, fontSize: 17)
        btnFemale.setTitleColor(greyColor, for: .normal)
        btnFemale.setTitleColor(redColor, for: .selected)
        
        btnMale.titleLabel?.font = getFont(fontName: _font_Montserrat_SemiBold, fontSize: 17)
        btnMale.setTitleColor(greyColor, for: .normal)
        btnMale.setTitleColor(redColor, for: .selected)
        
        btnOther.titleLabel?.font = getFont(fontName: _font_Montserrat_SemiBold, fontSize: 17)
        btnOther.setTitleColor(greyColor, for: .normal)
        btnOther.setTitleColor(redColor, for: .selected)
        
        txtAlreadySignUp.delegate = self
        txtAlreadySignUp.textColor = whiteColor
        txtAlreadySignUp.backgroundColor = clearColor
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        paragraph.alignment = .center
        
        let fontAttributeRegular = getFont(fontName: _font_Montserrat_Regular, fontSize: 17.0)
        let fontAttributeSemiBold = getFont(fontName: _font_Montserrat_SemiBold, fontSize: 15.0)
        
        let attributedString = NSMutableAttributedString(string: "Already have an account? ", attributes:
        [NSAttributedString.Key.foregroundColor : whiteColor, NSAttributedString.Key.font : fontAttributeRegular])
        
        let linkRangeForAllString = attributedString.mutableString.range(of: txtAlreadySignUp.text)
        attributedString.setAttributes([.paragraphStyle: paragraph, NSAttributedString.Key.foregroundColor : whiteColor, NSAttributedString.Key.font : fontAttributeRegular], range: linkRangeForAllString)
        
        attributedString.append(NSMutableAttributedString(string: "SIGN IN", attributes:[.link: URL(string: kURLSIGNIN)!, NSAttributedString.Key.font : fontAttributeSemiBold]))
        
        self.txtAlreadySignUp.attributedText = attributedString
        self.txtAlreadySignUp.isUserInteractionEnabled = true
        self.txtAlreadySignUp.isEditable = false

        // Set how links should appear: blue and underlined
        self.txtAlreadySignUp.linkTextAttributes = [
            .foregroundColor: redColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        
        
        self.lblSelectAgeTopConstraint.constant = -42
        self.viewPassword.isHidden = true
    }
    
    // MARK: - UITextView
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == kURLSIGNIN) {
            // Do whatever you want here as the action to the user pressing your 'actionString'
            self.navigationController?.popToRootViewController(animated: true)
        }
        return false
    }

    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        if validate() {
            if isEdit {
                self.navigationController?.popViewController(animated: true)
            }else {
                callApiForSignUp()
            }
        }
    }
    
    @IBAction func btnSelectAge(_ sender: Any) {
        self.view.endEditing(false)
        
        var arrDate : [String] = ["    Select Age"]
        for i in 0 ... 99{
            arrDate.append("    " + String(i + 1))
        }
                         
        let dropDown = DropDown()
                                
        // The view to which the drop down will appear on
        dropDown.anchorView = self.viewSelectAge// UIView or UIBarButtonItem
                                
        dropDown.backgroundColor = whiteColor
        dropDown.cornerRadius = 8
        dropDown.textFont = getFont(fontName: _font_Montserrat_Regular, fontSize: 17)
        dropDown.textColor = greyColor
        dropDown.cellHeight = 60
        dropDown.separatorColor = greyColor
        dropDown.selectionBackgroundColor = greyColor_0_5
        dropDown.arrowIndicationX = (dropDown.anchorView?.plainView.frame.width)! - 40
                                
        // Top of drop down will be below the anchorView
        dropDown.bottomOffset = CGPoint(x: 0, y: 16 + (dropDown.anchorView?.plainView.bounds.height)!)
                                
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = arrDate
                                
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("Selected item: \(item) at index: \(index)")
            dropDown.hide()
            self.btnSelectAge.setTitle(item.trimmed, for: .normal)
        }
                                
        dropDown.direction = .bottom
                                
        dropDown.show()
    }
    
    @IBAction func btnFemale(_ sender: Any) {
        updateGender(button: self.btnFemale)
    }
    @IBAction func btnMale(_ sender: Any) {
        updateGender(button: self.btnMale)
    }
    @IBAction func btnOther(_ sender: Any) {
        updateGender(button: self.btnOther)
    }
    
    func updateGender(button: UIButton) {
        self.btnFemale.isSelected = false
        self.btnMale.isSelected = false
        self.btnOther.isSelected = false
        
        if button == self.btnFemale {
            self.btnFemale.isSelected = true
        }
        if button == self.btnMale {
            self.btnMale.isSelected = true
        }
        if button == self.btnOther {
            self.btnOther.isSelected = true
        }
    }
    
    func validate() -> Bool {
        
        if txtFullName.text == "" {
            self.showToast(message: _empty_full_name, delay: 2.0)
            return false
        }/*else if txtEmail.text == "" {
            self.showToast(message: _empty_email, delay: 2.0)
            return false
        }else if isValidEmail(txtEmail.text ?? "") == false {
            self.showToast(message: _error_invalid_email, delay: 2.0)
            return false
        }else if txtPassword.text == "" && viewPassword.isHidden == false{
            self.showToast(message: _empty_password, delay: 2.0)
            return false
        }else if btnSelectAge.titleLabel?.text?.trimmed.elementsEqual("Select Age") == true {
            self.showToast(message: _error_select_age, delay: 2.0)
            return false
        }else if btnMale.isSelected == false && btnFemale.isSelected == false && btnOther.isSelected == false {
            self.showToast(message: _invalid_gender, delay: 2.0)
            return false
        }*/
        
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK:- WebServices

    func callApiForSignUp() {
               
        showProgress()
        
        var gender = ""
        
        if btnMale.isSelected == true {
            gender = _text_gender_male
        }else if btnFemale.isSelected == true {
            gender = _text_gender_female
        }else if btnOther.isSelected == true {
            gender = _text_gender_other
        }
        
        let params = [
            "mobile" : mobileNumber ?? "",
            "email" : txtEmail.text ?? "",
            "name" : txtFullName.text ?? "",
            "age": btnSelectAge.titleLabel?.text?.trimmed ?? "",
            "gender" : gender,
            "password" : txtPassword.text ?? "",
         ] as [String : Any]
             
        print(params)
        
        createUser(dictUserDetails: params as NSDictionary)
    }
    
    func createUser(dictUserDetails: NSDictionary)  {

        if dictUserDetails.count > 0 {
            let userData = [
                "id": String(dictUserDetails.value(forKey: "mobile") as? String ?? ""),
                "full_name": dictUserDetails.value(forKey: "name") as? String ?? "",
                "lastseen": Date().toLocalTime().toGlobalTime().toString(dateFormat: "yyyy-MM-dd HH:mm:ss"),
                "email": dictUserDetails.value(forKey: "email") as? String ?? "",
                "image": dictUserDetails.value(forKey: "image") as? String ?? "",
                "mobile": dictUserDetails.value(forKey: "mobile") as? String ?? "",
                "online": "true"
            ]
            let userId = String(dictUserDetails.value(forKey: "mobile") as? String ?? "")
            
            Database.database().reference().child("users").child(userId).updateChildValues(userData)

            setDictionary(dictionary: userData as NSDictionary, _key: _key_UserDetails)
            
            delay(bySeconds: 3.0) {
                closeProgress()
                
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        }
    }
}
