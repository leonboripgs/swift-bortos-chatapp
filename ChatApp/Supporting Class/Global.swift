//
//  Global.swift
//  ChatApp
//
//  Created by Chandresh Kachariya on 14/08/19.
//  Copyright © 2019 Chandresh Kachariya. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import AVKit

class Global: NSObject {

}

var Timestamp: String {
   return "\(NSDate().timeIntervalSince1970 * 1000)"
}

extension CALayer {
    func roundCorners(cornerRadius: Double) {
        self.cornerRadius = CGFloat(cornerRadius)
        self.masksToBounds = true
    }
    
    func roundBorder(cornerRadius: Double, color: UIColor) {
        self.cornerRadius = CGFloat(cornerRadius)
        self.borderColor = color.cgColor;
        self.borderWidth = 1.0
        self.masksToBounds = true
    }
    
    func roundBorder(cornerRadius: Double, color: UIColor, borderWith: Double) {
        self.cornerRadius = CGFloat(cornerRadius)
        self.borderColor = color.cgColor;
        self.borderWidth = CGFloat(borderWith)
        self.masksToBounds = true
    }
}

// MARK : - Extention
public extension String {
    var isEmptyStr:Bool{
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces).isEmpty
    }
    var trimmed:String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var escapedString:String{
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func toDate( dateFormat formate : String ) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let parsedDate:Date = dateFormatter.date(from: self)!
        
        dateFormatter.dateFormat = formate;//"yyyy-MM-dd' 'HH:mm:ss"
        let newDateString = dateFormatter.string(from: parsedDate)
        
        return dateFormatter.date(from: newDateString)!
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var firstCharacterOfEachWord: String {
        
        let stringInput = self
        let stringInputArr = stringInput.components(separatedBy: " ")
        var stringNeed = ""

        for string in stringInputArr {
            stringNeed = stringNeed + String(string.first!)
        }

        print(stringNeed)
        return stringNeed
    }
    
}

extension Date {
    
    func toString( dateFormat format  : String ) -> String
    {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: Date(timeInterval: seconds, since: self))
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    /*
     // Try it
     let utcDate = Date().toGlobalTime()
     let localDate = utcDate.toLocalTime()
     
     print("utcDate - (utcDate)")
     print("localDate - (localDate)")
     */
}

// MARK : - UIScrollView
extension UIScrollView {
    func scrollsToBottom(animated: Bool) {
        if #available(iOS 11.0, *) {
            let bottomOffset = CGPoint(x: contentOffset.x,
                                       y: contentSize.height - bounds.height + adjustedContentInset.bottom)
            setContentOffset(bottomOffset, animated: animated)
        } else {
            // Fallback on earlier versions
            let bottomOffset: CGPoint = CGPoint(x: 0, y: self.contentSize.height - self.bounds.size.height + self.contentInset.bottom)
            self.setContentOffset(bottomOffset, animated: true)

        }
    }
}

// MARK : - delay thread
public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
    let dispatchTime = DispatchTime.now() + seconds
    dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
}
public enum DispatchLevel {
    case main, userInteractive, userInitiated, utility, background
    var dispatchQueue: DispatchQueue {
        switch self {
        case .main:                 return DispatchQueue.main
        case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
        case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
        case .utility:              return DispatchQueue.global(qos: .utility)
        case .background:           return DispatchQueue.global(qos: .background)
        }
    }
}


// MARK : - Font
public func getFont(fontName: String, fontSize: CGFloat) -> UIFont {
    return UIFont(name: fontName, size: fontSize)!
}

// MARK : - Email
public func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}

public func openLinkInSafari(url: URL) {
    UIApplication.shared.open(url)
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size

    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height

    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }

    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return newImage!
}

func getTimesAgo(fromDate: Date, toDate: Date) -> String {

    let difference = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: fromDate, to: toDate)
    
    if difference.year != 0 {
        return String(difference.year!) + " year ago"
    }else if difference.month != 0 {
        return String(difference.month!) + " month ago"
    }else if difference.day != 0 {
        return String(difference.day!) + " day ago"
    }else if difference.hour != 0 {
        return String(difference.hour!) + " hour ago"
    }else if difference.minute != 0 {
        return String(difference.minute!) + " minute ago"
    }else {
        return "Just now"
    }
}

let _str_today = "today"
let _str_yesterday = "yesterday"

public func getLastSeenTodayOrYesterday(messageDate: Date) -> String {
 
    var strLastSeen = ""
    
    let today = Date()
    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())

    if messageDate.toString(dateFormat: "yyyy-MM-dd").elementsEqual(today.toString(dateFormat: "yyyy-MM-dd")) {
        strLastSeen = "today"
    }else if messageDate.toString(dateFormat: "yyyy-MM-dd").elementsEqual(yesterday!.toString(dateFormat: "yyyy-MM-dd")) {
        strLastSeen = "yesterday"
    }
    
    return strLastSeen
}

func requestAuthorization(completion: @escaping ()->Void) {
        if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (status) in
                DispatchQueue.main.async {
                    completion()
                }
            }
        } else if PHPhotoLibrary.authorizationStatus() == .authorized{
            completion()
        }
    }



func saveVideoToAlbum(_ outputURL: URL, _ completion: ((Error?) -> Void)?) {
    requestAuthorization {
        
        showProgress()
        
        delay(bySeconds: 0.3) {
            if let url = URL(string: outputURL.absoluteString), let urlData = NSData(contentsOf: url) {
            let galleryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
            let filePath="\(galleryPath)/nameX.mp4"

            urlData.write(toFile: filePath, atomically: true)
                PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL:
                URL(fileURLWithPath: filePath))
            }) {
                success, error in
                    delay(bySeconds: 0.3) {
                        closeProgress()
                    }
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Saved successfully")
                    }
                    completion?(error)
                }
            }
        }
    }
}

func playVideo(viewController: UIViewController, strUrl: String) {
    let player = AVPlayer(url: URL.init(string: strUrl)!)

    let vc = AVPlayerViewController()
    vc.player = player

    viewController.present(vc, animated: true) { vc.player?.play() }
}
