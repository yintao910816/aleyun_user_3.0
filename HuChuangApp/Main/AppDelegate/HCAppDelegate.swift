//
//  AppDelegate.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift
import HandyJSON

@UIApplicationMain
class HCAppDelegate: UIResponder, UIApplicationDelegate {

     var window: UIWindow?

    public var deviceToken: String = ""
    
    public var isAuthorizedPush: Bool = false
    
    public var allowRotation: Bool = false
    
    public var disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupTRTC()
        setupUM(launchOptions: launchOptions)
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        window?.rootViewController = HCTabBarViewController()
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        setupAppLogic()
        
        return true
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if allowRotation {
            return .landscapeLeft
        }else {
            return .portrait
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        DispatchQueue.main.async {
            if NSObject().visibleViewController?.isKind(of: HCH5ViewController.self) == true {
                NotificationCenter.default.post(name: NotificationName.Pay.wChatPayFinish, object: nil)
            }
        }
    }
        
    func applicationDidEnterBackground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}
