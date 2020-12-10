//
//  PhoneRegisterVC.swift
//  ChatApp
//
//  Created by Chandresh Kachariya on 03/09/20.
//  Copyright © 2020 Fascinate Infotech. All rights reserved.
//

import UIKit
import Alamofire

class PhoneRegisterVC: UIViewController {

    @IBOutlet weak var lblLoading: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initSetup()
        
        theAppDelegate?.navigationController = self.navigationController
        
//        if getDictionary(_key: _key_UserDetails).count > 0 {
//            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatVC") as? ChatVC
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }
        
    }
    
    func initSetup() {
        let uuid = UIDevice.current.identifierForVendor?.uuidString
        let url = BASE_API_URL + _api_route_account + _api_check_uuid
        print(url)
        let parameters = ["uuid": uuid]
        AF.request(URL.init(string: url)!, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers:nil).responseJSON { [self] (response) in

            if response.data != nil {
                switch response.result {
                case .success(let value):
                    
                    let json : [String:Any] = value as! [String : Any]
                    print(json)
                    let successVal = json["success"] as! Bool
                    if successVal == true {
                        
                        let resUserInfo = json["user"] as? [String: Any]
                        
                        let userInfo = [
                            "uuid": String(resUserInfo?["uuid"] as? String ?? ""),
                            "full_name": String(resUserInfo?["name"] as? String ?? ""),
                            "photo": String(resUserInfo!["photo"] as? String ?? "")
                        ] as [String : Any]
                        print("get User info")
                        print(userInfo)
                        setDictionary(dictionary: userInfo as NSDictionary, _key: _key_UserDetails)
                        
                        lblLoading.text = "Redirecting to chat view..."
                        let vc = UIStoryboard.init(name: _storyboard_name, bundle: Bundle.main).instantiateViewController(identifier: "ChatVC") as? ChatVC
                        self.navigationController?.pushViewController(vc!, animated: true)
//
                        
                    } else {
                        lblLoading.text = "Sorry, this phone is not allowed."
                    }
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }


    // MARK: - VerifyPhoneNumberVC delegate method

    func didReceive(otp: String) {
        print(otp)
        
//        callForFirebaseVerifiyPhoneNumber(code: otp)
    }
    
}
