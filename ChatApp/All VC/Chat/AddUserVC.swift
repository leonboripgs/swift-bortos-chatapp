//
//  AddUserVC.swift
//  ChatApp
//
//  Created by Chandresh Kachariya on 05/11/20.
//

import UIKit
import FirebaseDatabase
import Alamofire

class AddUserVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    var arrUsers = NSMutableArray()
    
    /*************  UITableView  ************************/
    @IBOutlet weak var tblUserList: UITableView!
    var refreshControl = UIRefreshControl()

    /*************  UILabel  ************************/
    @IBOutlet weak var lblTitle: UILabel!
    
    /*************  UIView  ************************/
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var navigationBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initSetup()
        
        loadUsers()
    }
    
    func initSetup() {
        setNavigationTitle(label: lblTitle)
        
        tblUserList.estimatedRowHeight = 44
        tblUserList.dataSource = self
        tblUserList.delegate = self
        tblUserList.register(UINib(nibName: reuseIdentifierChatTVCell, bundle: nil), forCellReuseIdentifier: reuseIdentifierChatTVCell)

        tblUserList.tableFooterView = UIView.init()
        
        //refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        tblUserList.addSubview(refreshControl)
    }
    
    // MARK: - loadUsers

    func loadUsers() {
        let url = BASE_API_URL + _api_route_account + _api_get_all_users

        AF.request(URL.init(string: url)!, method: .get, encoding: JSONEncoding.default, headers:nil).responseJSON { [self] (response) in
            if response.data != nil {
                switch response.result {
                case .success(let retVal):
                    let json : [String:Any] = retVal as! [String : Any]
                    let successVal = json["success"] as! Bool
                    if successVal == true {
                        let resContacts = json["doc"] as? [Any] ?? []
                        for contact in resContacts {
                            let contactInfo = contact as! [String: Any]
                            
                            let user = [
                                "uuid": contactInfo["uuid"] as! String,
                                "full-name": contactInfo["name"] as! String,
                                "photo": contactInfo["photo"] as! String,
                            ]
                            if (user["uuid"])!.elementsEqual(getDictionary(_key: _key_UserDetails).value(forKey: "uuid") as! String) {
                                continue
                            }else {
                                self.arrUsers.add(user)
                            }
                            
                        }
                        self.tblUserList.reloadData()
                    }
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
//        let recipientData = Database.database().reference().child("users")
//        recipientData.observeSingleEvent(of: .value, with: { (snapshot) in
//
//            print(snapshot)
//            //po (((snapshot.value as! Dictionary<String, AnyObject>) as NSDictionary).allKeys as! NSArray).object(at: 1)
//            if snapshot.exists() {
//
//                let dictUserList = ((snapshot.value as! Dictionary<String, AnyObject>) as NSDictionary)
//
//                let arrUsersID = dictUserList.allKeys as! NSArray
//                for item in arrUsersID {
//                    let userID = item as! String
//
//                    let dictUser = dictUserList.value(forKey: userID) as! NSDictionary
//                    if (dictUser.value(forKey: "id") as! String).elementsEqual(getDictionary(_key: _key_UserDetails).value(forKey: "id") as! String) {
//                        continue
//                    }else {
//                        self.arrUsers.add(dictUser)
//                    }
//
//                }
//                self.tblUserList.reloadData()
//            }
//
//        })
    }
    
    // MARK: - IBAction
    @IBAction func btnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITableView
    let reuseIdentifierChatTVCell = "ChatTVCell"

    @objc func refresh(sender:AnyObject) {
       // Code to refresh table view
        refreshControl.endRefreshing()
        
        self.arrUsers.removeAllObjects()
        
        loadUsers()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return messageDetail.count
        return self.arrUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierChatTVCell, for: indexPath) as! ChatTVCell

        let dictUser: NSDictionary = arrUsers.object(at: indexPath.row) as! NSDictionary
        print(dictUser)
        cell.lblName.text = dictUser.value(forKey: "full-name") as? String ?? ""
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
        let dictUser: NSDictionary = arrUsers.object(at: indexPath.row) as! NSDictionary

        let recipientUUID = dictUser.value(forKey: "uuid") as! String
        let name = dictUser.value(forKey: "full-name") as! String

        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SingleChatVC") as? SingleChatVC
        let detail = MessageDetail(recipient: name, uuid: recipientUUID, lastMsg: "")
        vc?.recipient = recipientUUID
        vc?.messageDetail = detail
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
