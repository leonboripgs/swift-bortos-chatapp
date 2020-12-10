//
//  SingleChatVC.swift
//  BunTwo
//
//  Created by Chandresh Kachariya on 09/05/20.
//  Copyright © 2020 Fascinate Infotech. All rights reserved.
//
// Multi selection tableview
// 1. https://medium.com/@mrachamallu/multiple-row-selection-with-check-buttons-for-uitableviewcells-programmatically-efb36507891
// 2. https://github.com/mrachamallu/MultiSelectExample

import UIKit
import AVKit
import IQKeyboardManagerSwift
import DropDown
import MobileCoreServices

import Lightbox
import SocketIO
import Alamofire

var _msgTypeText = "text"
var _msgTypeImage = "image"
var _msgTypeFile = "file"
var _msgTypeVideo = "video"

//Not set BaseViewController
class SingleChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var messageId: String!
    var messageDetail: MessageDetail!
    var recipientFcmToken:String?
        
    var messages = [Message]()
    
    var socket:SocketIOClient!
    
    //var message: Message!
    
    var currentUser = String(getDictionary(_key: _key_UserDetails).value(forKey: "uuid") as! String)
    
    var recipient: String!
    var recipientImage: String!

    /*************  NSLayoutConstraint  ************************/
    @IBOutlet weak var viewMoreHightConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewTypingBottomConstraint: NSLayoutConstraint!
    
    /*************  UIView  ************************/
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var viewMore: UIView!
    @IBOutlet weak var viewTyping: UIView!
    @IBOutlet weak var viewTypingBar: UIView!
    @IBOutlet weak var viewBottomStatusBar: UIView!
    @IBOutlet weak var viewOptionSelectMessage: UIView!
    
    /*************  UIImageView  ************************/
    @IBOutlet weak var imgProfie: UIImageView!
    
    /*************  UILabel  ************************/
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLastSeen: UILabel!
    @IBOutlet weak var lbLineSelectMessage: UILabel!
    @IBOutlet weak var lbLineMuteNotification: UILabel!
    @IBOutlet weak var lbLineClearMessage: UILabel!

    /*************  UIButton  ************************/
    @IBOutlet weak var btnSelectMessage: UIButton!
    @IBOutlet weak var btnMuteNotification: UIButton!
    @IBOutlet weak var btnClearMessage: UIButton!
    @IBOutlet weak var btnDelectChat: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var btnAttachment: UIButton!
    @IBOutlet weak var btnSend: UIButton!
    
    /*************  UITextField  ************************/
    @IBOutlet weak var txtMessage: UITextField!
    
    /*************  UITableView  ************************/
    @IBOutlet weak var tblChatList: UITableView!
    var refreshControl = UIRefreshControl()

    var viewTypingBottomConstraintIsSetOnlyKeyboardHeight = false
    
    /*************  MediaPickerPresenter  ************************/
    var attachmentManager: AttachmentManager = AttachmentManager()

    var picker = UIImagePickerController();

    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false

        // Do any additional setup after loading the view.
        socket = theAppDelegate?.socket
        addSocketHandlers()
        initView()
        
//        if theAppDelegate?.isKeyboardAlreadyOpenOneTime == false {
//            viewTypingBottomConstraintIsSetOnlyKeyboardHeight = true
//        }
        showProgress()
        loadData()
    
    }
    
    // MARK: - initView
    func initView() {
        self.btnCamera.isHidden = true
        self.btnAttachment.isHidden = true
        
        txtMessage.inputAccessoryView = UIView()

        viewTyping.translatesAutoresizingMaskIntoConstraints = false;
//        viewTypingBar.dropShadow(color: barColor, opacity: 0.75, offSet: CGSize(width: -1, height: 1), radius: 2, scale: false)
        
        //statusBar.backgroundColor = barColor
        //navigationBar.backgroundColor = barColor
        //setNavigationBarShadow(navigationBar: navigationBar)
//        viewTyping.backgroundColor = bottomBarColor
//        viewBottomStatusBar.backgroundColor = bottomBarColor

        //self.viewMoreHightConstraint.constant = 0
        self.viewMore.alpha = 0
        self.viewMore.isHidden = false
        self.viewMore.layer.roundBorder(cornerRadius: 0, color: lightGrayColor, borderWith: 1)
        self.viewMore.dropShadow(color: blackColor_0_5, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 2, scale: false)
        
        imgProfie.layer.roundCorners(cornerRadius: Double(imgProfie.frame.size.height/2))
        
        setNavigationTitle(label: lblName)
        
        lblLastSeen.textColor = whiteColor
        //lblLastSeen.font = getFont(fontName: _font_Montserrat_Light, fontSize: 12)
        
        lbLineSelectMessage.backgroundColor = lightGrayColor
        lbLineMuteNotification.backgroundColor = lightGrayColor
        lbLineClearMessage.backgroundColor = lightGrayColor

        btnSelectMessage.setTitleColor(grayColor, for: UIControl.State.normal)
        //btnSelectMessage.titleLabel?.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 14)
        
        btnMuteNotification.setTitleColor(grayColor, for: UIControl.State.normal)
        //btnMuteNotification.titleLabel?.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 14)
        
        btnClearMessage.setTitleColor(grayColor, for: UIControl.State.normal)
        //btnClearMessage.titleLabel?.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 14)
        
        btnDelectChat.setTitleColor(grayColor, for: UIControl.State.normal)
        //btnDelectChat.titleLabel?.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 14)
        
        tblChatList.estimatedRowHeight = 44
        tblChatList.dataSource = self
        tblChatList.delegate = self
        tblChatList.register(UINib(nibName: reuseIdentifierChatLeftTextTVCell, bundle: nil), forCellReuseIdentifier: reuseIdentifierChatLeftTextTVCell)
        tblChatList.register(UINib(nibName: reuseIdentifierChatRightTextTVCell, bundle: nil), forCellReuseIdentifier: reuseIdentifierChatRightTextTVCell)
        tblChatList.register(UINib(nibName: reuseIdentifierChatRightImageTVCell, bundle: nil), forCellReuseIdentifier: reuseIdentifierChatRightImageTVCell)
        tblChatList.register(UINib(nibName: reuseIdentifierChatLeftImageTVCell, bundle: nil), forCellReuseIdentifier: reuseIdentifierChatLeftImageTVCell)

        tblChatList.tableFooterView = UIView.init()
        
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tblChatList.addSubview(refreshControl)
        
        btnCamera.backgroundColor = cameraBGColor
        btnCamera.layer.roundCorners(cornerRadius: Double(btnCamera.frame.size.height/2))
        
        btnSend.backgroundColor = blueColor
        btnSend.layer.roundCorners(cornerRadius: Double(btnCamera.frame.size.height/2))
        
        txtMessage.delegate = self
        txtMessage.textColor = grayColor
        txtMessage.attributedPlaceholder = NSAttributedString(string: "Typ hier uw bericht in", attributes: [NSAttributedString.Key.foregroundColor: grayColor]) //Type your message
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
        //tblChatList.scrollToBottom(animated: false)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        UIBarButtonItem.appearance().tintColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardNotifications()
        self.view.endEditing(true)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: -SocketPart
    func addSocketHandlers() {
        socket.on("receive:message") {data, ack in
            print("new message arrived")
            print(data)
            let msg : [String: Any] = data[0] as! [String: Any]
            let post = Message(message: msg["message"] as? String ?? "", from: msg["from"] as? String ?? "", to: msg["to"] as? String ?? "", messageTime: msg["messageTime"] as? String ?? "", isDeleted: msg["isDeleted"] as? Bool ?? false)
            print(post.messageTime)
            self.messages.append(post)
            
            
            self.tblChatList.reloadData()
            delay(bySeconds: 0.5) {
                if self.messages.count > 0 {
                    self.tblChatList.scrollToBottom(animated: true)
                }
                closeProgress()
            }
            removeAllSubView(parentView: self.tblChatList)
            self.tblChatList.addSubview(self.refreshControl)
        }
    }
    
    // MARK: - keyboard Methods
    var savedBottomConstraint : CGFloat?
    
    override func keyboardWillShow(notification: NSNotification) {
       
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("keyboardSize.height")
            print(keyboardSize.height)
            UIView.animate(withDuration: 0.3, animations: {
                /*if theAppDelegate!.isKeyboardAlreadyOpenOneTime == true {
                    self.viewTypingBottomConstraint.constant = -keyboardSize.height - self.viewTyping.frame.size.height
                }else if viewTypingBottomConstraintIsSetOnlyKeyboardHeight == true {
                    self.viewTypingBottomConstraint.constant = -keyboardSize.height + self.viewBottomStatusBar.frame.size.height
                    theAppDelegate!.isKeyboardAlreadyOpenOneTime = true
                }else */if self.viewTypingBottomConstraint.constant == 0 {
                    var minusDeviceHeight = 0
                    if UIDevice().userInterfaceIdiom == .phone {
                        switch UIScreen.main.nativeBounds.height {
                            case 1136:
                                print("iPhone 5 or 5S or 5C")
                                minusDeviceHeight = 30
                                
                            case 1334:
                                print("iPhone 6/6S/7/8")
                                minusDeviceHeight = 30
                                
                            case 1920, 2208:
                                print("iPhone 6+/6S+/7+/8+")
                                minusDeviceHeight = 30
                                
                            case 2436:
                                print("iPhone X/XS/11 Pro")

                            case 2688:
                                print("iPhone XS Max/11 Pro Max")

                            case 1792:
                                print("iPhone XR/ 11 ")

                            default:
                                print("Unknown")
                            }
                    }
                    self.viewTypingBottomConstraint.constant = -keyboardSize.height + self.navigationBar.frame.size.height - 20 - CGFloat(minusDeviceHeight)
                    print(self.viewTypingBottomConstraint.constant)
                }
                if (self.messages.count > 0) {
                    self.tblChatList.scrollToBottom(animated: false)
                }
                        
            }) { (Done) in

                self.savedBottomConstraint = self.viewTypingBottomConstraint.constant
            }
            self.savedBottomConstraint = self.viewTypingBottomConstraint.constant
        }
    }

    override func keyboardWillHide(notification: NSNotification) {
//        if self.viewTypingBottomConstraint.constant != 0 {
//            self.viewTypingBottomConstraint.constant = 0
//        }
        self.viewTypingBottomConstraint.constant = 0
    }
    
    // MARK: - LoadUsers
    func loadUsers() {
        /*
        Database.database().reference().child("users").child(currentUser).child("messages").observe(.value, with: { (snapshot) in
        
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                //self.messageDetail.removeAll()
                
                for data in snapshot {
                    
                    if let messageDict = data.value as? Dictionary<String, AnyObject> {
                        
                        let key = data.key
                        
                        let chatID = messageDict["recipient"] as! String
                        if self.recipient.elementsEqual(chatID) {
                            self.messageId = key
                            self.messageDetail = MessageDetail(messageKey: key, messageData: messageDict)
                        }
        
                    }
                }
            }
        
            if self.messageId != "" && self.messageId != nil {
                self.loadData()
            }else {
                delay(bySeconds: 0.3) {
                    closeProgress()
                }
            }
        })
 */
    }
    // MARK: - UserObserverEvent
    func userObserveEvent() {
        /*
        let usersData = Database.database().reference().child("users").child(recipient)
        usersData.observe(.value, with: { (snapshot) in
            
            let data = snapshot.value as! Dictionary<String, AnyObject>
            
            self.recipientFcmToken = data["fcm_token"] as? String ?? ""
            
            let username = data["full_name"]
            self.lblName.text = username as? String
            
            let online = data["online"] as! String
            if online == "true" {
                self.lblLastSeen.text = "Online"
            }else {
                let lastseen = data["lastseen"]
                if (lastseen != nil) {
                    self.lblLastSeen.text = "Last seen at " + ( (lastseen as? String)!.toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime().toString(dateFormat: "hh:mm a") )
                    
                    let strSeenInfo = getLastSeenTodayOrYesterday(messageDate: (lastseen as! String).toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime())
                    
                    if strSeenInfo.elementsEqual(_str_today) {
                        self.lblLastSeen.text = "Last seen today at " + (lastseen as! String).toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime().toString(dateFormat: "hh:mm a")
                    }else if strSeenInfo.elementsEqual(_str_yesterday) {
                        self.lblLastSeen.text = "Last seen yesterday at " + (lastseen as! String).toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime().toString(dateFormat: "hh:mm a")
                    }else {
                        self.lblLastSeen.text = "Last seen " + (lastseen as! String).toDate(dateFormat: "yyyy-MM-dd HH:mm:ss").toLocalTime().toLocalTime().toString(dateFormat: "MMM dd, yyyy")
                    }
                }
            }
            
            self.tblChatList.reloadData()
        })
 */
    }
    // MARK: - loadData
    func loadData() {
        
        loadRecipientDetails()
        
        self.messages.removeAll()
        let url = BASE_API_URL + _api_route_message + _api_get_convo
        let parameters = ["uuid": currentUser, "contactuuid": messageDetail.uuid]
        AF.request(URL.init(string: url)!, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers:nil).responseJSON { [self] (response) in
            if response.data != nil {
                switch response.result {
                case .success(let retVal):
                    let json : [String:Any] = retVal as! [String : Any]
                    let successVal = json["success"] as! Bool
                    if successVal == true {
                        let resConvo = json["convo"] as? [Any] ?? []
                        for message in resConvo {
                            let msg = message as! [String: Any]
                            let post = Message(message: msg["memo"] as? String ?? "", from: msg["from"] as? String ?? "", to: msg["to"] as? String ?? "", messageTime: msg["updated_at"] as? String ?? "", isDeleted: msg["deleted"] as? Bool ?? false)
                            print(post.messageTime)
                            self.messages.append(post)
                        }
                        self.tblChatList.reloadData()
                        delay(bySeconds: 0.5) {
                            if self.messages.count > 0 {
                                self.tblChatList.scrollToBottom(animated: false)
                            }
                            closeProgress()
                        }
                        removeAllSubView(parentView: self.tblChatList)
                        self.tblChatList.addSubview(self.refreshControl)
                    }
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }
    
    func loadRecipientDetails() {
        if messageDetail != nil {
            self.lblName.text = self.messageDetail.recipient
        }
    }
    //MARK: -sendMessage
    func sendMessage(msgType: String, userMessage: String, fileName: String) {
        let url = BASE_API_URL + _api_route_message + _api_send_message
        let parameters = ["from": currentUser, "to": messageDetail.uuid, "memo": userMessage]
        AF.request(URL.init(string: url)!, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers:nil).responseJSON { [self] (response) in
            if response.data != nil {
                switch response.result {
                case .success(let retVal):
                    print(retVal)
                    let json : [String:Any] = retVal as! [String : Any]
                    let successVal = json["success"] as! Bool
                    if successVal == true {
                        let msg: [String: Any] = (json["msg"] as? [String: Any])!
                        let post: Message = Message(message: msg["memo"] as? String ?? "", from: msg["from"] as? String ?? "", to: msg["to"] as? String ?? "", messageTime: msg["updated_at"] as? String ?? "", isDeleted: msg["deleted"] as? Bool ?? false)
                        print(post.messageTime)
                        self.messages.append(post)
                        
                        self.tblChatList.reloadData()
                        delay(bySeconds: 0.5) {
                            if self.messages.count > 0 {
                                self.tblChatList.scrollToBottom(animated: false)
                            }
                            closeProgress()
                        }
                        let msgData: [String: Any] = [
                            "from": post.from,
                            "to": post.to,
                            "message": post.message,
                            "isDeleted": post.isDeleted,
                            "messageTime": post.messageTime
                        ]
                        socket.emit("send:message", msgData)
                        
                        removeAllSubView(parentView: self.tblChatList)
                        self.tblChatList.addSubview(self.refreshControl)
                    }
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }
    
    func deleteAllChat() {
//        for message in messages {
//
//            print(message.message)
//
//            if messageId != "" {
//
//                let postUpdate: Dictionary<String, AnyObject> = [
//                    "fileName": message.fileName as AnyObject,
//                    "messageType": message.messageType as AnyObject,
//                    "messageTime": message.messageTime as AnyObject,
//                    "sender": message.sender as AnyObject,
//                    "messageVisibility" : message.messageVisibility as AnyObject,
//                    "isDeleted": "true" as AnyObject
//                ]
////                let firebaseMessage = Database.database().reference().child("messages").child(messageId).child(message.messageKey)
////                firebaseMessage.updateChildValues(postUpdate)
//
//            }
//        }
//
//        if messages.count > 0 {
//            let message = messages[messages.count - 1]
//
//            let messageUpdate: Dictionary<String, AnyObject> = [
//                "fileName": message.fileName as AnyObject,
//                "messageType": message.messageType as AnyObject,
//                "lastmessage": message.message as AnyObject,
//                "lastMessageTime": message.messageTime as AnyObject,
//                "recipient": recipient as AnyObject,
//                "messageVisibility" : message.messageVisibility as AnyObject,
//                "isDeleted": "true" as AnyObject
//            ]
//
//            let recipientMessageUpdate: Dictionary<String, AnyObject> = [
//                "fileName": message.fileName as AnyObject,
//                "messageType": message.messageType as AnyObject,
//                "lastmessage": message.message as AnyObject,
//                "lastMessageTime": message.messageTime as AnyObject,
//                "recipient": currentUser as AnyObject,
//                "messageVisibility" : message.messageVisibility as AnyObject,
//                "isDeleted": "true" as AnyObject
//            ]
//
//            let recipentMessage = Database.database().reference().child("users").child(recipient).child("messages").child(messageId)
//            recipentMessage.updateChildValues(recipientMessageUpdate)
//
//            let userMessage = Database.database().reference().child("users").child(currentUser).child("messages").child(messageId)
//            userMessage.updateChildValues(messageUpdate)
//
//            loadData()
//        }

    }
    
    func updateMessageVisibility() {
//
//        for message in messages {
//
//            print(message.message)
//
//            if messageId != "" {
//
//                let messageVisibility = message.messageVisibility
//                let parsed = messageVisibility.replacingOccurrences(of: currentUser, with: "")
//
//                let postUpdate: Dictionary<String, AnyObject> = [
//                    "fileName": message.fileName as AnyObject,
//                    "messageType": message.messageType as AnyObject,
//                    "message": message.message as AnyObject,
//                    "messageTime": message.messageTime as AnyObject,
//                    "sender": message.sender as AnyObject,
//                    "messageVisibility" : parsed as AnyObject,
//                    "isDeleted": message.isDeleted as AnyObject
//                ]
//                let firebaseMessage = Database.database().reference().child("messages").child(messageId).child(message.messageKey)
//                firebaseMessage.updateChildValues(postUpdate)
//
//            }
//        }
//
//        if messages.count > 0 {
//            let message = messages[messages.count - 1]
//
//            let messageVisibility = message.messageVisibility
//            let parsed = messageVisibility.replacingOccurrences(of: currentUser, with: "")
//
//            let messageUpdate: Dictionary<String, AnyObject> = [
//                "fileName": message.fileName as AnyObject,
//                "messageType": message.messageType as AnyObject,
//                "lastmessage": message.message as AnyObject,
//                "lastMessageTime": message.messageTime as AnyObject,
//                "recipient": recipient as AnyObject,
//                "messageVisibility" : parsed as AnyObject,
//                "isDeleted": message.isDeleted as AnyObject
//            ]
//
//            let recipientMessageUpdate: Dictionary<String, AnyObject> = [
//                "fileName": message.fileName as AnyObject,
//                "messageType": message.messageType as AnyObject,
//                "lastmessage": message.message as AnyObject,
//                "lastMessageTime": message.messageTime as AnyObject,
//                "recipient": currentUser as AnyObject,
//                "messageVisibility" : parsed as AnyObject,
//                "isDeleted": message.isDeleted as AnyObject
//            ]
//
//            let recipentMessage = Database.database().reference().child("users").child(recipient).child("messages").child(messageId)
//            recipentMessage.updateChildValues(recipientMessageUpdate)
//
//            let userMessage = Database.database().reference().child("users").child(currentUser).child("messages").child(messageId)
//            userMessage.updateChildValues(messageUpdate)
//
//            loadData()
//        }
        
    }
    
    func uploadImageToFirebase(image: UIImage,
                               success:@escaping (_ _result : Any? ) -> Void,
                               failer:@escaping (_ _result : Any? ) -> Void) {
//
//        showProgress()
//
//        let fileName = Timestamp
//        print("fileName: " + fileName)
//
//        let storageRef = Storage.storage().reference().child("Chat/" + fileName + ".jpeg")
//        if let uploadData = image.jpegData(compressionQuality: 0.1) {
//            storageRef.putData(uploadData, metadata: nil , completion: { (metadata, error) in
//
//                delay(bySeconds: 0.3) {
//                    closeProgress()
//                }
//
//                if error != nil {
//                    print("error")
//                    failer("Failed" + (error?.localizedDescription ?? ""))
//                }
//                else {
//
//                    storageRef.downloadURL(completion: { (url, error) in
//                        print("Image URL: \((url?.absoluteString)!)")
//
//                        delay(bySeconds: 0.3) {
//                            success(url?.absoluteString)
//                        }
//                    })
//
//                }
//            })
//        }
    }
    
    func uploadFileToFirebase(fileUrl: URL,
                               success:@escaping (_ _result : Any? ) -> Void,
                               failer:@escaping (_ _result : Any? ) -> Void) {
//
//        showProgress()
//
//        let fileName = Timestamp
//        print("fileName: " + fileName)
//
//        let storageRef = Storage.storage().reference().child("Chat/" + fileName + "." + (fileUrl.pathExtension ))
//        let uploadTask = storageRef.putFile(from: fileUrl)
//
//        let observer = uploadTask.observe(.success) { snapshot in
//          // A progress event occured
//            print(snapshot)
//            if snapshot.error == nil {
//                storageRef.downloadURL(completion: { (url, error) in
//
//                    print("File URL: \((url?.absoluteString)!)")
//                    delay(bySeconds: 0.3) {
//                        closeProgress()
//                        success(url?.absoluteString)
//                    }
//                })
//            }
//        }
//
//        uploadTask.observe(.failure) { snapshot in
//            print(snapshot)
//            delay(bySeconds: 0.3) {
//                closeProgress()
//                failer("Failed")
//            }
//        }
    }
    
    func uploadTOFireBaseVideo(url: URL,
                                      success : @escaping (String) -> Void,
                                      failure : @escaping (Error) -> Void) {
/*
        showProgress()
        
        let name = Timestamp + ".mp4"
        let path = NSTemporaryDirectory() + name

        let dispatchgroup = DispatchGroup()

        dispatchgroup.enter()

        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let outputurl = documentsURL.appendingPathComponent(name)
        var ur = outputurl
        self.convertVideo(toMPEG4FormatForVideo: url as URL, outputURL: outputurl) { (session) in

            ur = session.outputURL!
            dispatchgroup.leave()

        }
        dispatchgroup.wait()

        let data = NSData(contentsOf: ur as URL)

        do {

            try data?.write(to: URL(fileURLWithPath: path), options: .atomic)

        } catch {

            print(error)
        }

        let storageRef = Storage.storage().reference().child("Chat").child(name)
        if let uploadData = data as Data? {
            storageRef.putData(uploadData, metadata: nil
                , completion: { (metadata, error) in
                    if let error = error {
                        failure(error)
                    }else{
                        //let strPic:String = (metadata?.downloadURL()?.absoluteString)!
                        //success("strPic")
                        storageRef.downloadURL(completion: { (url, error) in
                            print("Image URL: \((url?.absoluteString)!)")
                            
                            delay(bySeconds: 0.3) {
                                closeProgress()
                                
                                success(url!.absoluteString)
                            }
                        })
                    }
            })
        }
 */
    }
    
    func convertVideo(toMPEG4FormatForVideo inputURL: URL, outputURL: URL, handler: @escaping (AVAssetExportSession) -> Void) {
        /*
        //try! FileManager.default.removeItem(at: outputURL as URL)
        let asset = AVURLAsset(url: inputURL as URL, options: nil)

        let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        exportSession.outputURL = outputURL
        exportSession.outputFileType = .mp4
        exportSession.exportAsynchronously(completionHandler: {
            handler(exportSession)
        })
 */
    }
    
    // MARK:- WebServices
    
    @objc func callApiForSendPushNotification(user_id: String, message: String) {
        
        let paramsNotification = [
            "title" : self.lblName.text ?? "",
            "body" : message,
            "mutable_content" : true,
            "sound" : "Tri-tone"
        ] as [String : Any]
        
        let paramsTO = [
            "to" : self.recipientFcmToken ?? "",
            "notification" : paramsNotification
         ] as [String : Any]
                
        print(paramsTO)

        HttpClientApi.instance().fireFirebaseNotification(url: "https://fcm.googleapis.com/fcm/send", params: paramsTO, showLoading: false,  methods: .POST, success: { (data) in
            //po (data as! [String : Any])["user_data"]
            
            let success = (data as! [String : Any])["success"] as! Bool
            if success {
                
            }else {
                //Helper.showAlert(title: (data as! [String : Any])["message"] as? String, message: nil)
            }
                        
        }) { (fail) in
            //Helper.showAlert(title: fail as? String, message: nil)
        }
    
    }
    
    // MARK: - UITableView
    let reuseIdentifierChatLeftTextTVCell = "ChatLeftTextTVCell"
    let reuseIdentifierChatRightTextTVCell = "ChatRightTextTVCell"
    let reuseIdentifierChatRightImageTVCell = "ChatRightImageTVCell"
    let reuseIdentifierChatLeftImageTVCell = "ChatLeftImageTVCell"

    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        refreshControl.endRefreshing()
        
        showProgress()
//        if messageId != "" && messageId != nil {
//            loadData()
//        }else {
//            loadUsers()
//        }
        loadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    // MARK: - UITableView-ViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        if message.from != currentUser {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierChatLeftTextTVCell, for: indexPath) as! ChatLeftTextTVCell
            
            if tblChatList.isEditing == true {
                cell.selectionStyle = .gray
            }else {
                cell.selectionStyle = .none
            }
            
            cell.configureCell(message: message)
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierChatRightTextTVCell, for: indexPath) as! ChatRightTextTVCell
            
            if tblChatList.isEditing == true {
                cell.selectionStyle = .gray
            }else {
                cell.selectionStyle = .none
            }
            
            cell.configureCell(message: message)
            
            return cell
        }
        
        
        /*
        let message = messages[indexPath.row]
        
        if message.sender != currentUser {
            
            if (message.messageType).elementsEqual(_msgTypeText) {
               let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierChatRightTextTVCell, for: indexPath) as! ChatRightTextTVCell
               
               if tblChatList.isEditing == true {
                   cell.selectionStyle = .gray
               }else {
                   cell.selectionStyle = .none
               }
               
               cell.configureCell(message: message)
               
               return cell
            }
            else {
                //Image
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierChatRightImageTVCell, for: indexPath) as! ChatRightImageTVCell
                
                if tblChatList.isEditing == true {
                    cell.selectionStyle = .gray
                }else {
                    cell.selectionStyle = .none
                }
                
                cell.configureCell(message: message)
                
                cell.btnTapImage.addTarget(self, action: #selector(viewImages(sender:)), for: UIControl.Event.touchUpInside)
                
                return cell
            }

            
        }else {
            
            if (message.messageType).elementsEqual(_msgTypeText) {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierChatLeftTextTVCell, for: indexPath) as! ChatLeftTextTVCell
                
                cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControl.Event.touchUpInside)

                if tblChatList.isEditing == true {
                    cell.selectionStyle = .gray
                }else {
                    cell.selectionStyle = .none
                }
                
                cell.configureCell(message: message)
                
                let recipientData = Database.database().reference().child("users").child(messageDetail.recipient)
                recipientData.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let data = snapshot.value as! Dictionary<String, AnyObject>
                    
                    let username = data["full_name"]
                    self.lblName.text = username as? String
                    
                    self.recipientImage = (data["image"] as? String ?? "")
                    cell.imgProfle.getImage(url: BASEIMAGEURL + self.recipientImage, placeholderImage: UIImage.init(named: "profile"), success: { (success) in
                        
                        cell.imgProfle.contentMode = .scaleAspectFill
                    }) { (faild) in
                    }
                })
                
                if (self.lblLastSeen.text?.elementsEqual("Online"))! {
                    cell.lblOnline.isHidden = false
                }else {
                    cell.lblOnline.isHidden = true
                }
                
                return cell
                
            }
            else {
                //Image
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierChatLeftImageTVCell, for: indexPath) as! ChatLeftImageTVCell
                
                cell.btnProfile.addTarget(self, action: #selector(btnProfile(_:)), for: UIControl.Event.touchUpInside)

                if tblChatList.isEditing == true {
                    cell.selectionStyle = .gray
                }else {
                    cell.selectionStyle = .none
                }
                
                cell.configureCell(message: message)
                
                cell.btnTapImage.addTarget(self, action: #selector(viewImages(sender:)), for: UIControl.Event.touchUpInside)

                let recipientData = Database.database().reference().child("users").child(messageDetail.recipient)
                recipientData.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let data = snapshot.value as! Dictionary<String, AnyObject>
                    
                    let username = data["full_name"]
                    self.lblName.text = username as? String
                    
                    self.recipientImage = (data["image"] as? String ?? "")
                    cell.imgProfle.getImage(url: BASEIMAGEURL + self.recipientImage, placeholderImage: UIImage.init(named: "profile"), success: { (success) in
                        
                        cell.imgProfle.contentMode = .scaleAspectFill
                    }) { (faild) in
                    }
                })
                
                if (self.lblLastSeen.text?.elementsEqual("Online"))! {
                    cell.lblOnline.isHidden = false
                }else {
                    cell.lblOnline.isHidden = true
                }
                
                return cell
                
            }
            
            
        }
 */
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
    }
    
    //tableview Editing style
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if tableView.isEditing {
            return true
        }
        return false
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if tblChatList.isEditing {
            return true
        }else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        tableView.reloadData()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        // Toggles the actual editing actions appearing on a table view
        tblChatList.setEditing(editing, animated: true)
    }
    
    @objc func viewImages(sender:UIButton){
         
//        self.view.endEditing(true)
        /*
        let indexPath : IndexPath?
        
        let cell = sender.superview?.superview?.superview as? ChatLeftImageTVCell
        if cell == nil {
            let cell = sender.superview?.superview?.superview as? ChatRightImageTVCell
            if cell == nil {
                return
            }else {
                indexPath = tblChatList.indexPath(for: cell!)
            }
        }else {
            indexPath = tblChatList.indexPath(for: cell!)
        }
        
        let message = messages[indexPath!.row]

        if (message.messageType).elementsEqual(_msgTypeImage) {
            
            var images: [LightboxImage]? = []

            images?.append(LightboxImage(imageURL: URL(string: message.message)!) )

            // Create an instance of LightboxController.
            let controller = LightboxController(images: images!)

            // Set delegates.
            //controller.pageDelegate = self
            //controller.dismissalDelegate = self

            // Use dynamic background.
            controller.dynamicBackground = true
            
            controller.footerView.isHidden = true
            
            // Present your controller.
            self.present(controller, animated: true, completion: nil)
        }
 */
        
    }
    
    // MARK: - UITextField Delegate Methods

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        // return NO to disallow editing.
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        // became first responder
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField)
    {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    }

    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason)
    {
        // if implemented, called in place of textFieldDidEndEditing:
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        // return NO to not change text
        if savedBottomConstraint != nil {
            self.viewTypingBottomConstraint.constant = savedBottomConstraint!
        }
        print(viewTyping.frame)
        print(self.view.frame)
        self.view.layoutIfNeeded()
        self.view.updateFocusIfNeeded()
        if string.elementsEqual("\n") {
            self.view.endEditing(true)
        }
        return true
    }


    func textFieldShouldClear(_ textField: UITextField) -> Bool
    {
        // called when clear button pressed. return NO to ignore (no notifications)
        return true
    }

    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnProfile(_ sender: Any) {

//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ProfileDetailsVC") as? ProfileDetailsVC
//        //vc?.agent_id = recipient
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnSendMessage(_ sender: Any) {
        if (txtMessage.text != nil && txtMessage.text != "") {
            
            sendMessage(msgType: _msgTypeText, userMessage: txtMessage.text!, fileName: "")

            txtMessage.text = ""
        }
    }
    
    @IBAction func btnCamrera(_ sender: Any) {
//        ImagePickerManager().pickImage(self, { (image) in
//            print("sssss")
//        })
        self.view.endEditing(true)
        openCameraForImage()
        
    }
    
    @IBAction func btnAttachment(_ sender: Any) {
        self.view.endEditing(true)
        presentAttachmentActionSheet()
    }
    
    @IBAction func btnMore(_ sender: UIButton) {
//        if self.viewMore.alpha == 0 {
//            openMoreMenu(isOpen: true)
//        }else {
//            openMoreMenu(isOpen: false)
//        }
    
        let arrDate : [String] = ["Select messages", "Clear/Delete Messages"]

        let dropDown = DropDown()
        
        // The view to which the drop down will appear on
        dropDown.anchorView = self.viewMore// UIView or UIBarButtonItem
        
        dropDown.backgroundColor = whiteColor
        //dropDown.cornerRadius = 8
        //dropDown.textFont = getFont(fontName: _font_Montserrat_Regular, fontSize: 17)
        dropDown.textColor = textGrayColor
        dropDown.cellHeight = 60
        dropDown.separatorColor = lightGrayColor
        dropDown.selectionBackgroundColor = lightGrayColor
        dropDown.arrowIndicationX = (dropDown.anchorView?.plainView.frame.width)! - 33
        
        // Top of drop down will be below the anchorView
//        dropDown.bottomOffset = CGPoint(x: 0, y: 8 + (dropDown.anchorView?.plainView.bounds.height)!)
        
        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = arrDate
        
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
             print("Selected item: \(item) at index: \(index)")
             dropDown.hide()
            if index == 0 {
                self.view.endEditing(true)
                self.tblChatList.allowsMultipleSelectionDuringEditing = true
                self.tblChatList.isEditing = true
                self.tblChatList.reloadData()
                self.viewOptionSelectMessage.isHidden = false
            }else if index == 1 {
                self.updateMessageVisibility()
            }else if index == 3 {
                self.deleteAllChat()
            }
        }
        
        dropDown.direction = .bottom
        
        dropDown.show()
    }
    
    @IBAction func btnSelectMessage(_ sender: Any) {
        openMoreMenu(isOpen: false)
    }
    
    @IBAction func btnMuteNotification(_ sender: Any) {
        openMoreMenu(isOpen: false)
    }
    
    @IBAction func btnClearMessage(_ sender: Any) {
        openMoreMenu(isOpen: false)
    }
    
    @IBAction func btnDeleteChat(_ sender: Any) {
        openMoreMenu(isOpen: false)
    }
    
    func openMoreMenu(isOpen: Bool) {
        txtMessage.resignFirstResponder()
        self.view.layoutIfNeeded()
        if isOpen {
            self.viewMore.isHidden = false
        }
        UIView.animate(withDuration: 0.3, animations: {
            if isOpen {
                //self.viewMoreHightConstraint.constant = 195
                self.viewMore.alpha = 1
            }else {
                //self.viewMoreHightConstraint.constant = 0
                self.viewMore.alpha = 0
            }
            self.view.layoutIfNeeded()
        }) { (true) in
            if !isOpen {
                self.viewMore.isHidden = true
            }
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.tblChatList.allowsMultipleSelectionDuringEditing = false
        self.tblChatList.isEditing = false
        self.tblChatList.reloadData()
        self.viewOptionSelectMessage.isHidden = true
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        /*

        let selectedRows = self.tblChatList.indexPathsForSelectedRows
//        if selectedRows != nil {
//            print(selectedRows)
//            for var selectionIndex in selectedRows! {
//                while selectionIndex.item >= messages.count {
//                    selectionIndex.item -= 1
//                }
//                tableView(tblChatList, commit: .delete, forRowAt: selectionIndex)
//            }
//        }
        
        if selectedRows != nil {
            for selectionIndex in selectedRows! {
                let message = messages[selectionIndex.row]
                
                print(message.message)
                
                if messageId != "" {
                    let messageVisibility = message.messageVisibility
                    let parsed = messageVisibility.replacingOccurrences(of: currentUser, with: "")
                    
                    let postUpdate: Dictionary<String, AnyObject> = [
                        "message": message.message as AnyObject,
                        "messageTime": message.messageTime as AnyObject,
                        "sender": message.sender as AnyObject,
                        "messageVisibility" : parsed as AnyObject,
                        "isDeleted": "false" as AnyObject
                    ]
                    let firebaseMessage = Database.database().reference().child("messages").child(messageId).child(message.messageKey)
                    firebaseMessage.updateChildValues(postUpdate)
                    
                    if selectionIndex.row == (messages.count - 1) {
                        let messageUpdate: Dictionary<String, AnyObject> = [
                            "lastmessage": message.message as AnyObject,
                            "lastMessageTime": message.messageTime as AnyObject,
                            "recipient": recipient as AnyObject,
                            "messageVisibility" : parsed as AnyObject,
                            "isDeleted": "false" as AnyObject
                        ]
                        
                        let recipientMessageUpdate: Dictionary<String, AnyObject> = [
                            "lastmessage": message.message as AnyObject,
                            "lastMessageTime": message.messageTime as AnyObject,
                            "recipient": currentUser as AnyObject,
                            "messageVisibility" : parsed as AnyObject,
                            "isDeleted": "false" as AnyObject
                        ]
                        
                        let recipentMessage = Database.database().reference().child("users").child(recipient).child("messages").child(messageId)
                        recipentMessage.updateChildValues(recipientMessageUpdate)
                        
                        let userMessage = Database.database().reference().child("users").child(currentUser).child("messages").child(messageId)
                        userMessage.updateChildValues(messageUpdate)
                    }
                    
                    loadData()
                }
            }
        }
        
        self.tblChatList.allowsMultipleSelectionDuringEditing = false
        self.tblChatList.isEditing = false
        self.tblChatList.reloadData()
        self.viewOptionSelectMessage.isHidden = true
 
 */
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


}

//MARK: - Media Picker Presenter

extension SingleChatVC: MediaPickerPresenter {
    
    func attechmentSettings() {
        
        var titles = attachmentManager.settings.titles
        var settings = attachmentManager.settings
        
        //Customize titles
        titles.actionSheetTitle = "My title"
        titles.cancelTitle = "CANCEL"
        
        //Customize pickers settings
        settings.allowedAttachments = [.photoLibrary];
        settings.documentTypes = ["public.image"];
        
        settings.libraryAllowsEditing = true
        settings.cameraAllowsEditing = true
    }
    
    //MARK: - Media Picker Presenter Delegate
    
    func didSelectFromMediaPicker(_ file: FileInfo) {
        
        if file.url != nil {
            
            if file.mimeType.elementsEqual("video/quicktime") {
                uploadTOFireBaseVideo(url: file.url!, success: { (fileUrl) in
                    print(fileUrl)
                    
                    self.sendMessage(msgType: _msgTypeVideo, userMessage: fileUrl, fileName: file.fileName + ".mp4")
                    
                }) { (error) in
                    print(error as! String)
                }
            }else {
                uploadFileToFirebase(fileUrl: file.url!, success: { (fileUrl) in
                    print(fileUrl as! String)

                    if file.mimeType.elementsEqual("image/png") || file.mimeType.elementsEqual("image/jpeg") {
                        
                        self.sendMessage(msgType: _msgTypeImage, userMessage: fileUrl as! String, fileName: file.fileName + "." + (file.url?.pathExtension ?? ""))
                    }else {
                        self.sendMessage(msgType: _msgTypeFile, userMessage: fileUrl as! String, fileName: file.fileName + "." + (file.url?.pathExtension ?? ""))
                    }
                    
                }) { (error) in
                    print(error as! String)
                }
            }
        }
        else if file.mimeType.elementsEqual("image/png") || file.mimeType.elementsEqual("image/jpeg") {
            let dataImage = file.imageData
            
            delay(bySeconds: 0.3) {
                showProgress()
            }
            
            var image = UIImage.init(data: dataImage!)
            
            print(image)
            
//            image = image!.fixedOrientation()
            
            uploadImageToFirebase(image: image!, success: { (imgUrl) in
                print(imgUrl as! String)
                
                self.sendMessage(msgType: _msgTypeImage, userMessage: imgUrl as! String, fileName: file.fileName + ".png")
            }) { (error) in
                print(error as! String)
            }
            
        }else {
            
            
        }
        
        print("Picked file: \(file.fileName)")

    }
    
}

// MARK: - Camera

extension SingleChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @objc func openCameraForImage() {
        
        picker.delegate = self
        
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeImage as String]
            self.present(picker, animated: true, completion: nil)
                
        } else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    
    @objc func openCameraForVideo() {
        picker.delegate = self

        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.mediaTypes = [kUTTypeMovie as String]
            self.present(picker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as AnyObject
        
        if mediaType as! String == kUTTypeMovie as String {
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
            print("VIDEO URL: \(videoURL!)")
            picker.dismiss(animated: true, completion: nil)

            if videoURL != nil {
               
            }
        }else {
            guard var image = info[.originalImage] as? UIImage else { return }
            //image = image.fixedOrientation()
            
            uploadImageToFirebase(image: image, success: { (imgUrl) in
                print(imgUrl as! String)
                
                self.sendMessage(msgType: _msgTypeImage, userMessage: imgUrl as! String, fileName: "PDA Image.png")
            }) { (error) in
                print(error as! String)
            }
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }
}
