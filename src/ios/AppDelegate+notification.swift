//
//  AppDelegate+notification.swift
//  LinhTinhSwift
//
//  Created by Hoan Nguyen on 07/10/2020.
//  Copyright © 2020 Hoan Nguyen. All rights reserved.
//
import UIKit

extension AppDelegate {
  
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map {data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
}
