//
//  CustomFunciones.swift
//  QuickMenu
//
//  Created by Jesus Santiago Carrasco Campa on 06/03/18.
//  Copyright © 2018 Techson. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import SystemConfiguration


class storeKitFunc{
    
    let minRuns = 6
    let runIncrementerSetting = "numberOfRuns"
    
    func incrementAppRuns() {                   // counter for number of runs for the app. You can call this from App Delegate
        
        let usD = UserDefaults()
        let runs = getRunCounts() + 1
        usD.setValuesForKeys([runIncrementerSetting: runs])
        usD.synchronize()
        
    }
    
    func getRunCounts () -> Int {               // Reads number of runs from UserDefaults and returns it.
        
        let usD = UserDefaults()
        let savedRuns = usD.value(forKey: runIncrementerSetting)
        
        var runs = 0
        if (savedRuns != nil) {
            
            runs = savedRuns as! Int
        }
        
        print("Run Counts are \(runs)")
        return runs
        
    }
    
    func showReview() {
        
        let runs = getRunCounts()
        print("Show Review")
        
        if (runs > minRuns) {
            
            if #available(iOS 10.3, *) {
                print("Review Requested")
                SKStoreReviewController.requestReview()
                
            } else {
                // Fallback on earlier versions
            }
            
        } else {
            
            print("Runs are not enough to request review!")
            
        }
        
    }
    
    
}


public class checarInternetFunc {
    
    public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
}
























