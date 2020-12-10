//
//  AppDelegate.swift
//  ChatApp
//
//  Created by Chandresh Kachariya on 04/11/20.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import UserNotifications
import FirebaseMessaging
import FirebaseInstanceID
import SocketIO

let theAppDelegate = UIApplication.shared.delegate as? AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?
    var chatUserName: [String] = []
    
    let socketManager = SocketManager(socketURL: URL(string: "http://37.148.196.5:5000")!, config: [.log(false), .compress])
    
    var socket:SocketIOClient!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let frame = UIScreen.main.bounds
        
        self.window = UIWindow(frame: frame)
        self.window?.makeKeyAndVisible()
        IQKeyboardManager.shared.enable = true

        UIApplication.shared.statusBarStyle = .lightContent

        FirebaseApp.configure()
        self.registerForRemoteNotifications(application: application)
        Messaging.messaging().delegate = self
        
        socket = socketManager.defaultSocket
        
        return true
    }

    // MARK: UISceneSession Lifecycle
        
    func addSocketHandlers() {
        socket.on(clientEvent: .connect) {data, ack in
            print("App connected to socket server")
        }
    }
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        updateUserLastseen(isBackground: true)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
                
        updateUserLastseen(isBackground: false)

    }

    // MARK: - Push Notification 👇🏻
    
    //MARK:- Register for push notification.
    func registerForRemoteNotifications(application: UIApplication) {
    
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        
        debugPrint("Registering for Push Notification...")
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions?
       
             authOptions = [.alert, .badge, .sound]

        
        guard let authOption = authOptions else { return }
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOption, completionHandler: { (granted, error) in
                    if error == nil{
                        DispatchQueue.main.async(execute: {
                            application.registerForRemoteNotifications()
                        })
                    } else {
                        debugPrint("Error Occurred while registering for push \(String(describing: error?.localizedDescription))")
                    }
            })
        
        // Add observer for InstanceID token refresh callback.
       // NotificationCenter.default.addObserver(self, selector: #selector(self.tokenRefreshNotification), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
     // [END register_for_notifications]
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("ERROR: ", error)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.hexString
        Messaging.messaging().apnsToken = deviceToken
        print("DEVICE_TOKEN:  ",deviceTokenString)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([])
    }
    
    
    // Handle notification messages after display notification is tapped by the user.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        print(userInfo)
        completionHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        setValueUD(value: fcmToken, forkey: "fcm_token")
        self.sendFCMToken(key: fcmToken)
    }
    
    func tokenRefreshNotification(notification:NSNotification){
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                setValueUD(value: result.token, forkey: "fcm_token")
                self.sendFCMToken(key: result.token)
            }
        }
    }
    
    func sendFCMToken(key:String){
        
    }

    // MARK: - Push Notification 👆🏻`
}


// MARK:- Firebase Methods

extension AppDelegate {
    
    func updateUserLastseen(isBackground: Bool)  {
        let dictUserDetails: NSDictionary = getDictionary(_key: _key_UserDetails)
        if dictUserDetails.count > 0 {
            var userData = [
                "lastseen": Date().toLocalTime().toGlobalTime().toString(dateFormat: "yyyy-MM-dd HH:mm:ss"),
            ]
            if isBackground {
                userData["online"] = "false"
            }else {
                userData["online"] = "true"
            }
            
            let userId = String(dictUserDetails.value(forKey: "id") as! String)
            
            Database.database().reference().child("users").child(userId).updateChildValues(userData)
        }
    }
}
