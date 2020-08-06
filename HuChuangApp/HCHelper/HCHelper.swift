//
//  HCHelper.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCHelper {
    
    enum AppKeys: String {
        /// app schame
        case appSchame = "ileyun.ivfcn.com"
    }
    
    lazy var hud: NoticesCenter = {
        return NoticesCenter()
    }()
    
    private let disposeBag = DisposeBag()
    
    static let share = HCHelper()
    
    typealias blankBlock = ()->()

    public let userInfoHasReload = PublishSubject<HCUserModel>()
    public var userInfoModel: HCUserModel?
    public var isPresentLogin: Bool = false
    
    init() {
        
        let userInfoSignal = HCProvider.request(.selectInfo)
            .map(model: HCUserModel.self)

        NotificationCenter.default.rx.notification(NotificationName.UserInterface.jsReloadHome)
            .flatMap { _ in userInfoSignal }
            .subscribe(onNext: { user in
                HCHelper.saveLogin(user: user)
            })
            .disposed(by: disposeBag)
    }
    
    public static func setupHelper() {
        _ = HCHelper.share
    }
}

extension HCHelper {
    
    class func presentLogin(presentVC: UIViewController? = nil, isPopToRoot: Bool = false, _ completion: (() ->())? = nil) {
        HCHelper.share.isPresentLogin = true
        
        let loginSB = UIStoryboard.init(name: "HCLogin", bundle: Bundle.main)
        let loginControl = loginSB.instantiateViewController(withIdentifier: "loginControl")
        loginControl.modalPresentationStyle = .fullScreen
        
        let newPresentV = presentVC == nil ? NSObject().visibleViewController : presentVC
        newPresentV?.present(loginControl, animated: true, completion: {
            if isPopToRoot {
                newPresentV?.navigationController?.popViewController(animated: true)
            }
            completion?()
        })
    }
    
    func clearUser() {
        userDefault.uid = noUID
        userDefault.token = ""
        
        userInfoModel = nil
    }
    
    class func saveLogin(user: HCUserModel) {
//        NoticesCenter.alert(message: "更新unitId为\(user.unitId)")
        userDefault.uid = user.uid
        userDefault.token = user.token
        userDefault.unitId = user.unitId
        userDefault.unitIdNoEmpty = user.unitId

        HCHelper.share.userInfoModel = user
        
        HCHelper.share.userInfoHasReload.onNext(user)
    }

}

import AVFoundation
extension HCHelper {
    
    // 相机权限
    class func checkCameraPermissions() -> Bool {
        
        let authStatus : AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        
        if authStatus == AVAuthorizationStatus.denied || authStatus == AVAuthorizationStatus.restricted || authStatus == AVAuthorizationStatus.notDetermined {
            return false
        }else {
            return true
        }
    }
    
    class func authorizationForCamera(confirmBlock : @escaping blankBlock){
        
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
            DispatchQueue.main.async {
                if granted == true {
                    confirmBlock()
                }else{
                    NoticesCenter.alert(title: nil, message: "未能开启相机！")
                }
            }
        }
    }

}

extension HCHelper: VMNavigation {
    
    public class func preloadH5(type: H5Type, arg: String?) {
        _ = HCProvider.request(.unitSetting(type: type))
            .map(model: H5InfoModel.self)
            .subscribe(onSuccess: { HCHelper.pushH5(model: $0, arg: arg) }) { error in
                HCHelper.share.hud.failureHidden("功能暂不开放")
        }
    }
    
    public class func pushH5(href: String) {
        PrintLog("链接跳转地址: \(href)")
        HCHelper.push(BaseWebViewController.self, ["url": href])
    }
    
    public class func pushLocalH5(type: H5Type) {
        let urlString = type.getLocalUrl()
        PrintLog("固定链接跳转地址: \(urlString)")
        switch type {
        case .csRecord:
            HCHelper.push(HCOrderRecordController.self, ["url": urlString])
        default:
            HCHelper.push(BaseWebViewController.self, ["url": urlString])
        }
    }

    private class func pushH5(model: H5InfoModel, arg: String?) {
        guard model.setValue.count > 0 else { return }
        
        if model.setValue.count > 0 {
            var url = model.setValue
            PrintLog("h5拼接前地址：\(url)")
            if url.contains("?") == false {
                url += "?token=\(userDefault.token)&unitId=\(userDefault.unitId)"
            }else {
                url += "&token=\(userDefault.token)&unitId=\(userDefault.unitId)"
            }
            
            if let _arg = arg {
                url += "&userId=\(_arg)"
            }
            
            PrintLog("h5拼接后地址：\(url)")
            
            HCHelper.push(BaseWebViewController.self, ["url": url])
        }else {
            HCHelper.share.hud.failureHidden("功能暂不开放")
        }
        
        //        let url = "\(model.setValue)?token=\(userDefault.token)&unitId=\(AppSetup.instance.unitId)"
        //        HomeViewModel.push(BaseWebViewController.self, ["url": url])
    }
    
    public func requestH5(type: H5Type) ->Observable<H5InfoModel> {
        return HCProvider.request(.unitSetting(type: type))
            .map(model: H5InfoModel.self)
            .asObservable()
    }
}

extension HCHelper {
    
    /// 跳转到老版本爱乐孕
    class func openOldAleYun() {
        let urlStr = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=\(ileyun_appid)"
        guard let url = URL(string: urlStr)  else {
            NoticesCenter.alert(message: "跳转失败！")
            return
        }
        
        UIApplication.shared.openURL(url)
    }
}
