//
//  VerifyPhoneNumberVC.swift
//  ChatApp
//
//  Created by Chandresh Kachariya on 03/09/20.
//  Copyright © 2020 Fascinate Infotech. All rights reserved.
//

import UIKit
import SwiftyCodeView

protocol PhoneOTP {
    func didReceive(otp: String)
    func resendVerificaitionCode()
}

class VerifyPhoneNumberVC: UIViewController {

    var count = 20
    var timer:Timer?
    
    var delegatePhoneOTP: PhoneOTP?
    
    /*************  UIView  ************************/
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewPhoneVerification: CustomCodeView!
    
    /*************  UILabel  ************************/
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblSubDesc: UILabel!
    
    /*************  UIButton  ************************/
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnChangeNumber: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        initSetup()
        
        setTimer()
    }
    
    func initSetup() {
        viewPhoneVerification.delegate = self

        viewMain.layer.roundCorners(cornerRadius: Double(8))
        
        lblTitle.textColor = whiteColor
        lblTitle.font = getFont(fontName: _font_Montserrat_Bold, fontSize: 17)
        lblTitle.backgroundColor = redColor
        
        lblDesc.textColor = blackColor
        lblDesc.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 16)
        
        lblSubDesc.textColor = blackColor
        lblSubDesc.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 16)
        
        btnResend.setTitleColor(greyColor, for: UIControl.State.normal)
        btnResend.layer.roundBorder(cornerRadius: 12, color: redColor, borderWith: 0.0)
        btnResend.backgroundColor = greyColor_0_1
        btnResend.titleLabel?.font = getFont(fontName: _font_Montserrat_SemiBold, fontSize: 17)
        
        btnChangeNumber.setTitleColor(whiteColor, for: UIControl.State.normal)
        btnChangeNumber.layer.roundBorder(cornerRadius: 12, color: redColor, borderWith: 0.0)
        btnChangeNumber.backgroundColor = redColor
        btnChangeNumber.titleLabel?.font = getFont(fontName: _font_Montserrat_SemiBold, fontSize: 17)
        
    }

    func setTimer() {
        timer?.invalidate()
        timer = nil
        
        count = 20
        delay(bySeconds: 0.3) {
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        }
    }
    
    @objc func update() {
        if(count > 0) {
            count = count - 1
            UIView.performWithoutAnimation {
                btnResend.setTitle("Resend in " + String(count), for: UIControl.State.normal)
                btnResend.layoutIfNeeded()
            }

        }else {
            btnResend.setTitle("Resend", for: UIControl.State.normal)
            btnResend.layoutIfNeeded()
            
            timer?.invalidate()
            timer = nil
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnResend(_ sender: Any) {
        if (btnResend.titleLabel?.text?.elementsEqual("Verzenden"))! {
            self.dismiss(animated: true) {
                self.delegatePhoneOTP?.didReceive(otp: self.viewPhoneVerification.code)
            }
        }else if (btnResend.titleLabel?.text?.elementsEqual("Resend"))! {
            //Resend OTP
            setTimer()
            self.delegatePhoneOTP?.resendVerificaitionCode()
        }else {
            
        }
    }
    
    @IBAction func btnChangeNumber(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Swifty Code TextField Delegate
extension VerifyPhoneNumberVC: SwiftyCodeTextFieldDelegate, SwiftyCodeViewDelegate {
    
    func deleteBackward(sender: SwiftyCodeTextField, prevValue: String?) {
        print("Entered code: ", prevValue ?? 0 )
    }
    
    func codeView(sender: SwiftyCodeView, didFinishInput code: String) -> Bool {
        print("Entered code: ", code)

        timer?.invalidate()
        timer = nil
        
        btnResend.setTitle("Verzenden", for: .normal)
        
        return true
    }
}
