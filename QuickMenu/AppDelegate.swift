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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Llevar cuenta para lanzar feedback de la gente
        /*let funcionReview = storeKitFunc()
        funcionReview.incrementAppRuns()*/
        
        //Config. Ventana Principal
        window = UIWindow(frame: UIScreen.main.bounds)
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var initialVC = sb.instantiateViewController(withIdentifier: "OnBoarding")
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "onBoardingComplete") {
            
            initialVC = sb.instantiateViewController(withIdentifier: "QuickMenuInicio")
            
        }
        
        window?.rootViewController = initialVC
        window?.makeKeyAndVisible()
        
        
        //Config. Firebase
        FirebaseApp.configure()
        
        //Config. AdMob
        GADMobileAds.configure(withApplicationID: "ca-app-pub-7391736686492116~5717081292")
        
        //Config. Teclado
        IQKeyboardManager.sharedManager().enable = true
        
        //Config. SVProgressHUD
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setInfoImage(#imageLiteral(resourceName: "Idea"))
        SVProgressHUD.setErrorImage(#imageLiteral(resourceName: "Error"))
        
        //Configurar la barra de navegación
        UINavigationBar.appearance().tintColor = UIColor.white
        
        //Config. Push Notification
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            
            if error == nil{
                print("Autorizacion exitosa")
            }
            
        }
        application.registerForRemoteNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshToken(notification:)), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        Messaging.messaging().shouldEstablishDirectChannel = false
        application.applicationIconBadgeNumber = 0
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        FirebaseHandler()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    @objc func refreshToken(notification: NSNotification){
        
        let refreshToken = InstanceID.instanceID().token()!
        print("refreshToken: \(refreshToken)")
        
        FirebaseHandler()
        
    }
    
    
    func FirebaseHandler(){
        
        Messaging.messaging().shouldEstablishDirectChannel = true
        
    }
    
    


}









