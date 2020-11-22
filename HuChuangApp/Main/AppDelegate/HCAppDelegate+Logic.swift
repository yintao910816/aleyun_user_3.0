//
//  HCAppDelegate+Logic.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/22.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import StoreKit

import HandyJSON
import Alamofire

extension HCAppDelegate: SKStoreProductViewControllerDelegate {
    
    public func setupAppLogic() {
        HCHelper.setupHelper()
        DbManager.dbSetup()
        
        if HCHelper.userIsLogin() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                self.checkVersion()
            }
            
            if userDefault.loginInfoString.count == 0 {
                HCProvider.request(.selectInfo)
                    .map(model: HCUserModel.self)
                    .subscribe(onSuccess: { user in
                        HCHelper.saveLogin(user: user)
                    }) { error in
                        PrintLog(error)
                    }
                    .disposed(by: disposeBag)
            }else {
                if let user = JSONDeserializer<HCUserModel>.deserializeFrom(json: userDefault.loginInfoString) {
                    HCHelper.saveLogin(user: user)
                }
            }
        }
        
        //        if userDefault.lanuchStatue != vLaunch { AppLaunchView().show() }
    }
    
    private func checkVersion() {
        _ = HCProvider.request(.version)
            .map(model: AppVersionModel.self)
            .subscribe(onSuccess: { res in
                
                if Bundle.main.isNewest(version: res.versionName) == false
                {
                    NoticesCenter.alert(title: "有最新版本可以升级", message: "", cancleTitle: "取消", okTitle: "去更新", callBackOK: {
                        let storeProductVC = SKStoreProductViewController()
                        storeProductVC.delegate = self
                        storeProductVC.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier: ileyun_appid],
                                                   completionBlock:
                                                    { (flag, error) in
                                                        if flag
                                                        {
                                                            NSObject().visibleViewController?.present(storeProductVC, animated: true, completion: nil)
                                                        }
                                                    })
                    })
                }
            }) { error in
                print("--- \(error) -- 已是最新版本")
            }
    }
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
