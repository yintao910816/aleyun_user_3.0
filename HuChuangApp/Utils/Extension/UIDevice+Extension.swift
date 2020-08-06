//
//  UIDevice+Extension.swift
//  StoryReader
//
//  Created by 020-YinTao on 2017/11/9.
//  Copyright © 2017年 020-YinTao. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    
    /**
     判断是否为刘海屏
     */
    public var isX: Bool {
        if #available(iOS 11, *) {
            guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else { return false }
            
            if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
                return true
            }
        }
        return false
    }
}

extension UIDevice {
    
    class func switchNewOrientation(_ orientation: UIInterfaceOrientation) {
        
        let resetOrientationTarget = NSNumber.init(value: UIInterfaceOrientation.unknown.rawValue)
        UIDevice.current.setValue(resetOrientationTarget, forKey: "orientation")
        let orientationTarget = NSNumber.init(value: orientation.rawValue)
        UIDevice.current.setValue(orientationTarget, forKey: "orientation")
    }
}

extension UIDevice {
    
    /// 系统版本号
    static var iosVersion: String {
        get {
            return UIDevice.current.systemVersion
        }
    }
    
    //获取设备具体详细的型号
    static var modelName: String{
        get {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            switch identifier {
            case"iPod5,1":
                return"iPod Touch 5"
            case"iPod7,1":
                return"iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":
                return "iPhone4"
            case"iPhone4,1":
                return"iPhone4s"
            case"iPhone5,1","iPhone5,2":
                return"iPhone5"
            case "iPhone5,3", "iPhone5,4":
                return "iPhone5c"
            case "iPhone6,1", "iPhone6,2":
                return "iPhone5s"
            case"iPhone7,2":
                return"iPhone6"
            case"iPhone7,1":
                return"iPhone6 Plus"
            case"iPhone8,1":
                return"iPhone6s"
            case"iPhone8,2":
                return"iPhone6s Plus"
            case"iPhone8,4":
                return"iPhoneSE"
            case"iPhone9,1", "iPhone9,3":
                return"iPhone7"
            case "iPhone9,2", "iPhone9,4":
                return "iPhone7 Plus"
            case "iPhone10,1", "iPhone10,4":
                return "iPhone8"
            case "iPhone10,5", "iPhone10,2":
                return "iPhone8 Plus"
            case "iPhone10,3", "iPhone10,6":
                return "iPhoneX"
            case"iPhone11,2":
                return"iPhoneXS"
            case"iPhone11,6":
                return"iPhoneXS_MAX"
            case"iPhone11,8":
                return"iPhoneXR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":
                return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":
                return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":
                return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":
                return "iPad Air"
            case"iPad5,3", "iPad5,4":
                return"iPad Air 2"
            case "iPad2,5", "iPad2,6", "iPad2,7":
                return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":
                return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":
                return "iPad Mini 3"
            case"iPad5,1","iPad5,2":
                return"iPad Mini 4"
            case"iPad6,7","iPad6,8":
                return"iPad Pro"
            case"AppleTV5,3":
                return"Apple TV"
            case"i386","x86_64":
                return"Simulator"
            default:
                return identifier
            }
        }
    }
    
}
