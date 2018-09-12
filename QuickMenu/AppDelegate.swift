//
//  AppDelegate.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 21/01/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import SVProgressHUD
import UserNotifications
import PushNotifications
import GoogleMobileAds
import PusherSwift
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{

    var window: UIWindow?

    let pushNotifications = PushNotifications.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //Llevar cuenta para lanzar feedback de la gente
        let funcionReview = storeKitFunc()
        funcionReview.incrementAppRuns()
        
        //Config. Ventana Principal
        window = UIWindow(frame: UIScreen.main.bounds)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var initialVC = sb.instantiateViewController(withIdentifier: "OnBoarding")
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "onBoardingComplete") {
            
            initialVC = sb.instantiateViewController(withIdentifier: "InicioQuickMenu")
            
        }
        
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
        
        
        //Config. Firebase
        FirebaseApp.configure()
        
        //Facebook LogIn Config.
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Config. AdMob
        GADMobileAds.configure(withApplicationID: "ca-app-pub-7391736686492116~5717081292")
        
        //Config. Teclado
        IQKeyboardManager.shared.enable = true
        
        //Config. SVProgressHUD
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setInfoImage(#imageLiteral(resourceName: "Idea"))
        SVProgressHUD.setErrorImage(#imageLiteral(resourceName: "Error"))
        
        //Configurar la barra de navegación
        UINavigationBar.appearance().tintColor = UIColor.white
        
        
        //Config. Push Notification FCM
        /*if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
                
                if error == nil{
                    print("Autorizacion exitosa")
                }
                
            }
        } else {
            // Fallback on earlier versions
            
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
            
            let setting : UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(setting)
        }
        
        
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)*/
        
        //PushNotifications
        self.pushNotifications.start(instanceId: "ac68c8b1-6ab7-49da-b9e9-c626b14a5f69") //Antigua: ac68c8b1-6ab7-49da-b9e9-c626b14a5f69
        self.pushNotifications.registerForRemoteNotifications()
       
        let options = PusherClientOptions(
            host: .cluster("us2")
        )
        
        let pusher = Pusher(
            key: "d93192db4133cd10be10",
            options: options
        )
        
        // subscribe to channel and bind to event
        let channel = pusher.subscribe("my-channel")
        
        let _ = channel.bind(eventName: "my-event", callback: { (data: Any?) -> Void in
            if let data = data as? [String : AnyObject] {
                if let message = data["message"] as? String {
                    print(message)
                }
            }
        })
        
        pusher.connect()
        
        return true
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        //Facebook Config.
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        return handled
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
       
        //Messaging.messaging().shouldEstablishDirectChannel = false
        
        application.applicationIconBadgeNumber = 0
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //FirebaseHandler()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    /*func FirebaseHandler(){
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    @objc func refreshToken(notification: NSNotification){
        let refreshToken = InstanceID.instanceID().token()!
        print("---- \(refreshToken) ----")
        
        FirebaseHandler()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
    }*/
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        self.pushNotifications.registerDeviceToken(deviceToken) {
            try? self.pushNotifications.subscribe(interest: "universal")
        }
    }
    
    
    

}









