//
//  ChatVC.swift
//  BunTwo
//
//  Created by Chandresh Kachariya on 07/05/20.
//  Copyright © 2020 Fascinate Infotech. All rights reserved.
//  https://github.com/TheKaseys/MessagingAppTutorial

import UIKit
//import Firebase
//import FirebaseDatabase
import DropDown
import Alamofire
import SocketIO

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,  UITextFieldDelegate {
    
    var arrFriendsList = NSMutableArray()
    var arrFriendsListFiltered = NSMutableArray()

    var messageDetail = [MessageDetail]()
    
    var detail: MessageDetail!
    
    var currentUser = getDictionary(_key: _key_UserDetails).value(forKey: "uuid") as! String
    
    var recipient: String!
    
    var messageId: String!
    
    var socket: SocketIOClient!
        

    /*************  NSLayoutConstraint  ************************/
    @IBOutlet weak var viewSearchTopConstraint: NSLayoutConstraint!

    /*************  UIView  ************************/
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navigationBar: UIView!
    @IBOutlet weak var viewSearch: UIView!

    /*************  UILabel  ************************/
    @IBOutlet weak var lblTitle: UILabel!

    /*************  UITextField  ************************/
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var searchBar: UISearchBar!
    
    /*************  UITableView  ************************/
    @IBOutlet weak var tblChatList: UITableView!
    var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        self.viewSearchTopConstraint.constant = -54
        
        socket = theAppDelegate?.socket
        socket.connect()
        addSocketHandlers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        theAppDelegate?.navigationController = self.navigationController
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        loadUsers()
    }

    // MARK: - initView
    func initView() {
        txtSearch.delegate = self
        searchBar.delegate = self
        
        viewSearch.backgroundColor = barColor
        viewSearch.dropShadow(color: barColor, opacity: 0.75, offSet: CGSize(width: -1, height: 1), radius: 2, scale: false)
        
        setNavigationTitle(label: lblTitle)
        
        txtSearch.textColor = grayColor
        //txtSearch.font = getFont(fontName: _font_Montserrat_Regular, fontSize: 15)
        txtSearch.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: grayColor])
        
        searchBar.tintColor = grayColor
        searchBar.barTintColor = grayColor
        
        tblChatList.estimatedRowHeight = 44
        tblChatList.dataSource = self
        tblChatList.delegate = self
        tblChatList.register(UINib(nibName: reuseIdentifierChatTVCell, bundle: nil), forCellReuseIdentifier: reuseIdentifierChatTVCell)
        tblChatList.register(UINib(nibName: reuseIdentifierNewMatchesTVCell, bundle: nil), forCellReuseIdentifier: reuseIdentifierNewMatchesTVCell)

        tblChatList.tableFooterView = UIView.init()
        
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tblChatList.addSubview(refreshControl)
    }

    
    
    // MARK: -SocketPart
    func addSocketHandlers() {
        socket.on(clientEvent: .connect) { [self]data, ack in
            print("App connected to socket server")
            self.socket.emit("connect-user", self.currentUser)
        }
        socket.on("new-msg") { data, ack in
            print("contact list new message arrived")
        }
    }
    
    // MARK: - Load Users
    func loadUsers() {
        self.messageDetail.removeAll()
        let url = BASE_API_URL + _api_route_message + _api_get_contact_list
        let parameters = ["uuid": currentUser]
        AF.request(URL.init(string: url)!, method: .post, parameters: parameters as Parameters, encoding: JSONEncoding.default, headers:nil).responseJSON { [self] (response) in
            if response.data != nil {
                switch response.result {
                case .success(let retVal):
                    let json : [String:Any] = retVal as! [String : Any]
                    let successVal = json["success"] as! Bool
                    if successVal == true {
                        let resContacts = json["contact_list"] as? [Any] ?? []
                        for contact in resContacts {
                            let contactInfo = contact as! [String: Any]
                            let detail = MessageDetail(recipient: contactInfo["name"] as? String ?? "", uuid: contactInfo["uuid"] as? String ?? "", lastMsg: contactInfo["message"] as? String ?? "")
                            self.messageDetail.append(detail)
                        }
                    }
                    self.tblChatList.reloadData()
                    removeAllSubView(parentView: self.tblChatList)
                    self.tblChatList.addSubview(self.refreshControl)
                    if self.messageDetail.count <= 0 {
                        print("No conversation")
                        setLabelNotFound(parentView: self.tblChatList, message: "No Conversation available")
                    }
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }

    }
    
    // MARK: - UISearchBar Delegate Methods

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchText \(searchText)")
        self.tblChatList.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(searchBar.text)")
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.tblChatList.reloadData()
        self.btnSearch(self)
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
        if string.elementsEqual("\n") {
            self.view.endEditing(true)
        }
        /*delay(bySeconds: 0.3) {
            self.arrFriendsListFiltered = NSMutableArray()

            for item in self.arrFriendsList {
                let dictItem = item as! NSDictionary
                let name: String = ((dictItem.value(forKey: "data") as! NSDictionary).value(forKey: full_name) as? String ?? "").lowercased()
                if name.contains((self.txtSearch.text ?? "").lowercased()) {
                    self.arrFriendsListFiltered.add(item)
                }
            }
            if (self.txtSearch.text ?? "").elementsEqual("") {
                self.arrFriendsListFiltered = self.arrFriendsList
            }
            print(self.arrFriendsListFiltered.count)
            self.tblChatList.reloadData()
        }*/
        
        return true
    }
    
    // MARK: - UITableView
    let reuseIdentifierChatTVCell = "ChatTVCell"
    let reuseIdentifierNewMatchesTVCell = "NewMatchesTVCell"

    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        refreshControl.endRefreshing()
        loadUsers()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageDetail.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierChatTVCell, for: indexPath) as! ChatTVCell
        print(indexPath)
        let messageDet = self.messageDetail[indexPath.row]
        
        cell.configureCell(messageDetail: messageDet)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(indexPath)
        if indexPath.section == 0 {
            recipient = messageDetail[indexPath.row].recipient

            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SingleChatVC") as? SingleChatVC
            vc?.recipient = recipient
            vc?.messageDetail = messageDetail[indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if theAppDelegate?.chatUserName.count == 0 {
            return UITableView.automaticDimension
        }else if (searchBar.text ?? "").elementsEqual("") {
            return UITableView.automaticDimension
        }
        let userName = theAppDelegate?.chatUserName[indexPath.row]
        if ((userName?.uppercased().contains((searchBar.text ?? "").uppercased())) != nil) {
             return UITableView.automaticDimension
        }else {
             return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        }else {
            return false
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if (editingStyle == .delete) {
                // handle delete (by removing the data from your array and updating the tableview)
                
                let messageDet = messageDetail[indexPath.row]

                print(messageDet)
                
//                let messageUpdate: Dictionary<String, AnyObject> = [
//                    "isRemoveConversion": "true" as AnyObject
//                ]
                
//                let userMessage = Database.database().reference().child("users").child(currentUser).child("messages").child(messageDet.messageRef.key!)
//                userMessage.updateChildValues(messageUpdate)
            }
        }
    }

    func didSelectNewMatches(indexPath: IndexPath) {
        let dictItem = self.arrFriendsList.object(at: indexPath.row) as! NSDictionary
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SingleChatVC") as? SingleChatVC
        vc?.recipient = String((dictItem.value(forKey: "data") as! NSDictionary).value(forKey: "id") as! String)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // MARK: - IBAction
    @IBAction func btnSearchBarButton(_ sender: UIBarButtonItem) {
//        let objVC = self.storyboard?.instantiateViewController(withIdentifier: "SearchFriendsVC") as! SearchFriendsVC
//        self.navigationController?.pushViewController(objVC, animated: true)
        
        /*self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            if self.viewSearchTopConstraint.constant == 2 {
                self.viewSearchTopConstraint.constant = -54
                self.searchBar.resignFirstResponder()
                self.searchBar.text = ""
            }else {
                self.viewSearchTopConstraint.constant = 2
                self.searchBar.becomeFirstResponder()
            }
            self.view.layoutIfNeeded()
        }
        self.arrFriendsListFiltered = self.arrFriendsList
        self.tblChatList.reloadData()*/
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            if self.viewSearchTopConstraint.constant == 2 {
                self.viewSearchTopConstraint.constant = -54
                self.searchBar.resignFirstResponder()
                self.searchBar.text = ""
            }else {
                self.viewSearchTopConstraint.constant = 2
                self.searchBar.becomeFirstResponder()
            }
            self.view.layoutIfNeeded()
        }
        self.arrFriendsListFiltered = self.arrFriendsList
        self.tblChatList.reloadData()
    }
        
    @IBAction func btnConnection(_ sender: Any) {
//        let vc = UIStoryboard.init(name: _storyboard_name, bundle: Bundle.main).instantiateViewController(withIdentifier: _vc_ConnectionsVC) as? ConnectionsVC
//        self.navigationController?.pushViewController(vc!, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        let vc = UIStoryboard.init(name: _storyboard_name, bundle: Bundle.main).instantiateViewController(withIdentifier: _vc_AddUserVC) as? AddUserVC
        self.navigationController?.pushViewController(vc!, animated: true)
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
