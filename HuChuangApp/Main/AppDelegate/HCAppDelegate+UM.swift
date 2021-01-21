//
//  HCAppDelegate+UM.swift
//  HuChuangApp
//
//  Created by yintao on 2019/2/26.
//  Copyright © 2019 sw. All rights reserved.
//

private let AppKey = "5d5811164ca357b2690003a2"
private let AppSecret = "wnk8jo4tswwlyy5tkgsalypydl1hk0xh"

import Foundation

extension HCAppDelegate {
    
    func setupUM(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        registerAuthor()
        
        MobClick.setScenarioType(.E_UM_NORMAL)

        UMConfigure.setLogEnabled(true)

        UMConfigure.initWithAppkey(AppKey, channel: "App Store")

        let entity = UMessageRegisterEntity()
        entity.types = Int(UMessageAuthorizationOptions.badge.rawValue) | Int(UMessageAuthorizationOptions.alert.rawValue) | Int(UMessageAuthorizationOptions.sound.rawValue)
        
        UNUserNotificationCenter.current().delegate = self

        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, error) in
            if granted {
                PrintLog("UM注册成功")
            }else {
                PrintLog("UM注册失败")
            }
        }
        
        UMessage.setBadgeClear(true)
        
        _ = NotificationCenter.default.rx.notification(NotificationName.User.LoginSuccess, object: nil)
            .subscribe(onNext: { [weak self] _ in
                self?.uploadUMToken()
            })
    }
}

extension HCAppDelegate : UNUserNotificationCenterDelegate{
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var deviceTokenString = String()
        let bytes = [UInt8](deviceToken)
        for item in bytes {
            deviceTokenString += String(format:"%02x", item&0x000000FF)
        }
        PrintLog("推送token \(deviceTokenString)")
        
        UMessage.registerDeviceToken(deviceToken)
        
        self.deviceToken = deviceTokenString
        uploadUMToken()
        
        TRTCCalling.shareInstance().deviceToken = deviceToken
    }
    
    //收到远程推送消息
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UMessage.didReceiveRemoteNotification(userInfo)
        self.receiveRemoteNotificationForbackground(userInfo: userInfo)
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let information = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            UMessage.didReceiveRemoteNotification(information)
            self.receiveRemoteNotificationForbackground(userInfo: information)
        }else{
            //应用处于后台时的本地推送接受
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      
        let information = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.classForCoder()))! {
            //应用处于前台时的远程推送接受
            //必须加这句代码
            UMessage.didReceiveRemoteNotification(information)
            //关闭U-Push自带的弹出框
            UMessage.setAutoAlert(false)
            
            self.receiveRemoteNotificationForbackground(userInfo: information)
        }else{
            //应用处于前台时的本地推送接受
        }
        //当应用处于前台时提示设置，需要哪个可以设置哪一个
        completionHandler(UNNotificationPresentationOptions.badge)
    }
    
}

extension HCAppDelegate {
    
    private func receiveRemoteNotificationForbackground(userInfo : [AnyHashable : Any]){
        PrintLog(userInfo)
        
        DispatchQueue.main.async {
            HCHelper.pushLocalH5(type: .noticeAndMessage)
        }

//        let message = userInfo["alert"] as? String ?? "alert"
        
//        let tabVC = self.window?.rootViewController as! MainTabBarController
//        let selVC = tabVC.selectedViewController as! UINavigationController
//
//        let alertController = UIAlertController(title: "新消息提醒",
//                                                message: message, preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "知道了", style: .cancel, handler: nil)
//        let okAction = UIAlertAction(title: "马上查看", style: .default, handler: {(action)->() in
//            let notificationType = userInfo["notificationType"] as? String  ?? ""
//            switch notificationType {
//            case "21" :
//                HCPrint(message: "21")
//                let url = userInfo["url"] as? String ?? "http://www.ivfcn.com"
//                let webVC = WebViewController()
//                webVC.url = url
//                selVC.pushViewController(webVC, animated: true)
//            case "22" :
//                HCPrint(message: "22")
//                selVC.pushViewController(ConsultRecordViewController(), animated: true)
//            case "23" :
//                HCPrint(message: "23")
//                let survey = userInfo["url"] as! String
//                let webVC = WebViewController()
//                webVC.url = survey
//                selVC.pushViewController(webVC, animated: true)
//            default :
//                HCPrint(message: "default")
//                selVC.pushViewController(MessageViewController(), animated: true)
//            }
//        })
//        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
        
//        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    public func uploadUMToken() {
        guard deviceToken.count > 0, HCHelper.userIsLogin() else { return }

        UNUserNotificationCenter.current().getNotificationSettings { [weak self] (set) in
            guard let strongSelf = self else { return }
            if set.authorizationStatus == UNAuthorizationStatus.notDetermined{
                PrintLog("推送不允许")
                strongSelf.isAuthorizedPush = false
            }else if set.authorizationStatus == UNAuthorizationStatus.denied{
                PrintLog("推送不允许")
                strongSelf.isAuthorizedPush = false
            }else if set.authorizationStatus == UNAuthorizationStatus.authorized
            {
                PrintLog("推送允许")
                strongSelf.isAuthorizedPush = true
                _ = HCProvider.request(.UMAdd(deviceToken: strongSelf.deviceToken))
                    .mapResponse()
                    .subscribe(onSuccess: { res in
                        if RequestCode(rawValue: res.code) == RequestCode.success {
                            PrintLog("友盟token上传成功")
                        }else {
                            PrintLog(res.message)
                        }
                    }) { error in
                        PrintLog("友盟token上传失败：\(error)")
                }
            }
        }
    }
}

extension HCAppDelegate: WXApiDelegate {
    
    public func registerAuthor() {
        UMSocialManager.default()?.openLog(true)
        UMSocialManager.default()?.setPlaform(.wechatSession,
                                              appKey: weixinAppid,
                                              appSecret: weixinSecret,
                                              redirectURL: "http://mobile.umeng.com/social")
        
        UMSocialManager.default()?.setPlaform(.wechatTimeLine,
                                              appKey: weixinAppid,
                                              appSecret: weixinSecret,
                                              redirectURL: "http://mobile.umeng.com/social")
    }
    
    func onReq(_ req: BaseReq!) {
        PrintLog("wx onReq \(req)")
    }
    
    func onResp(_ resp: BaseResp!) {
        
    }
}

extension HCAppDelegate {
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
//        let urlString = url.absoluteString
//
//        if urlString.contains("wx") {
//            return WXApi.handleOpen(url, delegate: self)
//        }
                
        let result = UMSocialManager.default()?.handleOpen(url)
        return result!
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.absoluteString.contains(HCHelper.AppKeys.appSchame.rawValue) {
            NotificationCenter.default.post(name: NotificationName.Pay.wChatPayFinish, object: nil)
            return true
        }

//        return WXApi.handleOpen(url, delegate: self)
//        BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
        let result = UMSocialManager.default()?.handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        return result!
    }
}
