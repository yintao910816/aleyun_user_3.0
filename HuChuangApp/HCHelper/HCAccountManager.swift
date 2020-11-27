//
//  HCAccountManager.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/16.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCAccountManager {
        
    class func WeChatLogin() ->Observable<UMSocialUserInfoResponse?> {
        return Observable<UMSocialUserInfoResponse?>.create { obser -> Disposable in
            UMSocialManager.default()?.getUserInfo(with: .wechatSession, currentViewController: nil, completion: { (result, error) in
                if error != nil {
                    obser.onError(error!)
                }else {
                    PrintLog("微信openId： \((result as? UMSocialUserInfoResponse)?.openid)")
                    obser.onNext(result as? UMSocialUserInfoResponse)
                }
                obser.onCompleted()
            })
            
            return Disposables.create { }
        }
    }
}

extension HCAccountManager {
    // 分享
    class func presentShare(thumbURL: Any, title: String, descr: String, webpageUrl: String) {
        let messageObject = UMSocialMessageObject.init()
        let shareObject = UMShareWebpageObject.shareObject(withTitle: title, descr: descr, thumImage: thumbURL)!
        shareObject.webpageUrl = webpageUrl
        messageObject.shareObject = shareObject
        
        PrintLog("分享链接：\(shareObject.webpageUrl)")
    UMSocialUIManager.setPreDefinePlatforms([NSNumber(integerLiteral:UMSocialPlatformType.wechatSession.rawValue),NSNumber(integerLiteral:UMSocialPlatformType.wechatTimeLine.rawValue)])

        UMSocialUIManager.showShareMenuViewInWindow { (platformType, info) in
            UMSocialManager.default()?.share(to: platformType, messageObject: messageObject, currentViewController: NSObject().visibleViewController!, completion: { (data, error) in
                if error != nil {
                    print(error)
                }else {
                    if let result = data as? UMSocialShareResponse {
                        PrintLog(result)
//                        NoticesCenter.alert(message: "分享成功")
                    }else {
                        PrintLog("未知结果")
                    }
                }
            })
        }
    }
    
    /// App Store下载地址
    class func appstoreURL() ->String {
        let urlStr = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=\(ileyun_appid)"
        return urlStr
    }
}
