//
//  UIColor+LP.swift
//  LinhTinhSwift
//
//  Created by Hoan Nguyen on 7/1/20.
//  Copyright © 2020 Hoan Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    static let backgroundColor = UIColor(hex: "#FFFFFF")
    static let userBubbleBackgroundColor = UIColor(hex: "#00FFFF")

    static let remoteUserBubbleBackgroundColor = UIColor(hex: "#F0E2D4")
    static let remoteUserBubbleBorderColor = UIColor(hex: "#F0E2D4")
    static let remoteUserBubbleLinkColor = UIColor(hex: "#F0E2D4")
    static let remoteUserBubbleTextColor = UIColor(hex: "#636363")
    static let remoteUserBubbleTimestampColor = UIColor(hex: "#636363")
    static let remoteUserTypingTintColor = UIColor(hex: "#FFFFFF")
    static let remoteUserBubbleLongPressOverlayColor = UIColor(hex: "#C1C1C1")

    static let userBubbleBackgroundColor = UIColor(hex: "#152B55")
    static let userBubbleBorderColor = UIColor(hex: "#152B55")
    static let userBubbleLinkColor = UIColor(hex: "#152B55")
    static let userBubbleTextColor = UIColor(hex: "#FFFFFF")
    static let userBubbleTimestampColor = UIColor(hex: "#000000")
    static let userBubbleSendStatusTextColor = UIColor(hex: "#000000")
    static let userBubbleErrorTextColor = UIColor(hex: "#DB0011")
    static let userBubbleErrorBorderColor = UIColor(hex: "#DB0011")
    static let userBubbleLongPressOverlayColor = UIColor(hex: "#F5F5F5")

    
}



extension UIColor {
     convenience init(hex: String) {
           var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
           hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

           var rgb: UInt32 = 0

           var r: CGFloat = 0.0
           var g: CGFloat = 0.0
           var b: CGFloat = 0.0
           var a: CGFloat = 1.0

           let length = hexSanitized.count

        Scanner(string: hexSanitized).scanHexInt32(&rgb)

           if length == 6 {
               r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
               g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
               b = CGFloat(rgb & 0x0000FF) / 255.0

           } else if length == 8 {
               r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
               g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
               b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
               a = CGFloat(rgb & 0x000000FF) / 255.0

           }

           self.init(red: r, green: g, blue: b, alpha: a)
       }
}
