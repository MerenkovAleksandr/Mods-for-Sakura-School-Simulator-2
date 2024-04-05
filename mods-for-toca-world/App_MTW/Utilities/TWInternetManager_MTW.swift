//
//  TWInternetManager_MTW.swift
//  template
//
//  Created by Systems
//

import SystemConfiguration
import UIKit

final class TWInternetManager_MTW {
    
    static let shared = TWInternetManager_MTW()

    private init() {}
    
    func checkInternetConnectivity_MTW() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
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

        if isReachable && !needsConnection {
            // Connected to the internet
            // Do your network-related tasks here
            return true
        } else {
            // Not connected to the internet
            return false
        }
    }
    
    func getTopController(from: UIViewController? = nil) -> UIViewController? {
       var tryCount = 0
       
       if let controller = from {
           return controller
       } else if var controller = UIApplication.shared.windows.first?.rootViewController {
           while let presented = controller.presentedViewController, tryCount < 100 {
               tryCount += 1
               if let nav = presented as? UINavigationController, let last = nav.viewControllers.last {
                   controller = last
               } else if let vc = presented as UIViewController? {
                   controller = vc
               }
               DispatchQueue.main.async {
                   controller = presented
               }
           }
           return controller
       }
       return nil
   }
}
