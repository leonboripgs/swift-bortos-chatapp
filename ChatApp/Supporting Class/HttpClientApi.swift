//
//  HttpClientApi.swift
//  ChatApp
//
//  Created by Chandresh Kachariya on 17/12/19.
//  Copyright © 2019 Chandresh Kachariya. All rights reserved.
//

import UIKit
import Alamofire

//HTTP Methods
enum HttpMethod : String {
    case  GET
    case  POST
    case  DELETE
    case  PUT
}

class Connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

class HttpClientApi: NSObject {
    
    static func instance() ->  HttpClientApi{
        
        return HttpClientApi()
    }
    
    func fireFirebaseNotification(url: String,
                 params: Dictionary<String, Any>?,
                 showLoading : Bool,
                 methods: HttpMethod,
                 success:@escaping (_ _result : Any? ) -> Void,
                 failer:@escaping (_ _result : Any? ) -> Void) {
        
        if !Connectivity.isConnectedToInternet() {
               print("No! internet is available.")
               // do some tasks..
            failer(NO_INTERNET_CONNECTION)
            return
        }
        
        if showLoading {
            showProgress()
        }
        
        let headers: HTTPHeaders = [
          "Content-Type": "application/json",
            "Authorization": "key=AAAATAWKKdM:APA91bGuLrmLFSg01Sy3mD4gEcpsd_YZCwWfGwnlqgquu4p-F5uJed61RWHggKIyKh2mhPDz_2kUrdUd1ICgSRNxe648NQ_gBvd61OX6MV4pOPQaQh5T63ZdZQctjD8Q2w1R8ZOOzD_e"
        ]
        
        AF.request(url, method: HTTPMethod(rawValue: methods.rawValue) , parameters: params as? [String:Any], encoding: JSONEncoding.default, headers: headers)
             .responseJSON(completionHandler: { response in
                print(url)
                 debugPrint(response);
                if showLoading {
                    delay(bySeconds: 0.3) {
                        closeProgress()
                    }
                }

                if response.data != nil {

                    print("Result PUT Request:")
                    print(response)

                    switch response.result {

                        case .success(let value):
                            let json : [String:Any] = value as! [String : Any]
                            success(json)

                        case .failure(let error):
                            print(error)
                            failer(error.localizedDescription)
                    }
                }else{
                   failer("Data Not Found")
                }

             })
        }
    
    
    func callAPI(url: String,
                 params: Dictionary<String, Any>?,
                 showLoading : Bool,
                 methods: HttpMethod,
                 success:@escaping (_ _result : Any? ) -> Void,
                 failer:@escaping (_ _result : Any? ) -> Void) {
        
        var param = params
        if params != nil {
    
            param!["device_type"] = "ios"
            param!["device_token"] = "device_token"
            if getValueUD(forkey: "fcm_id") != "" {
                param!["device_token"] = getValueUD(forkey: "fcm_id")
            }
            param!["app_version"] = "1.0.0"
        }
        
        if !Connectivity.isConnectedToInternet() {
               print("No! internet is available.")
               // do some tasks..
            failer(NO_INTERNET_CONNECTION)
            return
        }
        
        if showLoading {
            showProgress()
        }
        
        var headers: HTTPHeaders = [
          "Accept": "application/json",
        ]
        if getValueUD(forkey: _key_token_auth) != "" {
            headers["Authorization"] = "Bearer " + getValueUD(forkey: _key_token_auth)
        }
        if getValueUD(forkey: "fcm_id") != "" {
            headers["device_token"] = getValueUD(forkey: "fcm_id")
        }
        
        AF.request(BASE_URL + url, method: HTTPMethod(rawValue: methods.rawValue) , parameters: param, headers: headers)
             .responseJSON(completionHandler: { response in
                        
                print(BASE_URL + url)
                
                 debugPrint(response);
                if showLoading {
                    delay(bySeconds: 0.3) {
                        closeProgress()
                    }
                }
                
                if response.data != nil {
                                
                    print("Result PUT Request:")
                    print(response)
                                          
                    switch response.result {
                        
                        case .success(let value):
                            let json : [String:Any] = value as! [String : Any]
                            success(json)
                            
                        case .failure(let error):
                            print(error)
                            failer(error.localizedDescription)
                    }
                }else{
                   failer("Data Not Found")
                }
                
             })
        }
    
    
    func callAPIWithImages(url: String,
                            params: [String: Any]?,
                            showLoading : Bool,
                            arrImage:[String: UIImage]?,
                            success:@escaping (_ _result : Any? ) -> Void,
                            failer:@escaping (_ _result : Any? ) -> Void){

        if !Connectivity.isConnectedToInternet() {
               print("No! internet is available.")
               // do some tasks..
            failer(NO_INTERNET_CONNECTION)
            return
        }
        
        var param = params
        if params != nil {
            param!["device_type"] = "ios"
            if getValueUD(forkey: "fcm_id") != "" {
                param!["device_token"] = getValueUD(forkey: "fcm_id")
            }
            param!["app_version"] = "1.0.0"
        }
                
            
        if showLoading {
            showProgress()
        }
        
        var headers: HTTPHeaders = [
          "Accept": "application/json",
          "Content-type": "multipart/form-data",
          "Content-Disposition" : "form-data"
        ]
        if getValueUD(forkey: _key_token_auth) != "" {
            headers["Authorization"] = "Bearer " + getValueUD(forkey: _key_token_auth)
        }
        if getValueUD(forkey: "fcm_id") != "" {
            headers["device_token"] = getValueUD(forkey: "fcm_id")
        }
        
        AF.upload(multipartFormData: { multipartFormData in

            if params != nil {
                for (key, value) in param! {
                    multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
            if arrImage != nil {
                for (key, value) in arrImage! {
                    guard let imgData = value.jpegData(compressionQuality: 1) else { return }
                    multipartFormData.append(imgData, withName: key, fileName: String(NSDate().timeIntervalSince1970 * 1000) + ".jpeg", mimeType: "image/jpeg")
                }
            }
            
        }, to: BASE_URL + url, usingThreshold: UInt64(Int64.init()), method: .post, headers: headers)
            .responseJSON { (response) in
                
                print(BASE_URL + url)
                
                debugPrint(response);

                if showLoading {
                    delay(bySeconds: 0.3) {
                        closeProgress()
                    }
                }
                
                if response.data != nil {
                                
                    print("Result PUT Request:")
                    print(response)
                                          
                    switch response.result {
                        
                        case .success(let value):
                            let json : [String:Any] = value as! [String : Any]
                            success(json)
                            
                        case .failure(let error):
                            print(error)
                            failer(error.localizedDescription)
                    }
                }else{
                    failer("Data Not Found")
                }
            }
        
    }
    
   func callAPIWithBodyData(url: String,
                            params: Dictionary<String, Any>?,
                            showLoading : Bool,
                            methods: HttpMethod,
                            success:@escaping (_ _result : Any? ) -> Void,
                            failer:@escaping (_ _result : Any? ) -> Void) {
          
    let dictParams: NSMutableDictionary = (params! as NSDictionary).mutableCopy() as! NSMutableDictionary 
    dictParams.setValue("ios", forKey: "device_type")
    dictParams.setValue("device_token", forKey: "device_token")
    dictParams.setValue("1.0.0", forKey: "app_version")
    if getValueUD(forkey: "fcm_id") != "" {
        dictParams.setValue(getValueUD(forkey: "fcm_id"), forKey: "device_token")
    }
    
    #if targetEnvironment(simulator)
       dictParams.setValue("OFF", forKey: "release_mode")
    #else
       dictParams.setValue("ON", forKey: "release_mode")
    #endif
    
    print(dictParams)
    
        if !Connectivity.isConnectedToInternet() {
               print("No! internet is available.")
               // do some tasks..
            delay(bySeconds: 0.3) {
              closeProgress()
              failer(NO_INTERNET_CONNECTION)
            }
            return
        }
        
        if showLoading {
            delay(bySeconds: 0.3) {
              showProgress()
            }
        }
        
        let urlString = BASE_URL + url
    
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            request.httpBody   = try JSONSerialization.data(withJSONObject: dictParams as Any)
        } catch let error {
            print("Error : \(error.localizedDescription)")
        }
        AF.request(request).responseJSON{ (response) in
                        
            // debugPrint(response);
            if showLoading {
                delay(bySeconds: 0.3) {
                  closeProgress()
                }
            }
             
            if response.data != nil {
                    
                    print("Result PUT Request:")
                    print(response)
                                          
                    switch response.result
                    {
                        
                    case .success(let value):
                        
                        let json : [String:Any] = value as! [String : Any]
                        let temp = json["Result"] as! NSDictionary
                        let status = temp.value(forKey: "status") as! String

                        if status == "FAIL" {
                            failer("Info Not Found")
                        }
                        else
                        {
                            success(temp)
                        }
                        
                    case .failure(let error):
                        print(error)
                    }
                }else{
                    
                }
    
            }
    }
    
    
    
}
