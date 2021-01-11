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

    /// 缓存的用户信息
    private var cachedLocalUsers: [CallingUserModel] = []

    public let userInfoHasReload = PublishSubject<HCUserModel>()
    public var userInfoModel: HCUserModel?
    public var isPresentLogin: Bool = false
    
    public var enableWchatLoginSubjet = PublishSubject<Bool>()
    public var enableWchatLogin: Bool = false

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
    
    class func userIsLogin() ->Bool {
        return userDefault.uid != noUID && userDefault.token.count > 0
    }
    
    class func presentLogin(presentVC: UIViewController? = nil, isPopToRoot: Bool = false, _ completion: (() ->())? = nil) {
        HCHelper.share.isPresentLogin = true
        HCHelper.share.clearUser()

        let loginControl = MainNavigationController.init(rootViewController: HCLoginViewController())
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
        userDefault.loginInfoString = ""
        
        userInfoModel = nil
    }
    
    class func saveLogin(user: HCUserModel) {
        userDefault.uid = user.uid
        userDefault.token = user.token
        userDefault.unitId = user.unitId
        userDefault.unitIdNoEmpty = user.unitId

        HCHelper.share.userInfoModel = user
        
        HCHelper.share.userInfoHasReload.onNext(user)
        
        if user.uid.count > 0 {
            (UIApplication.shared.delegate as! HCAppDelegate).uploadUMToken()
            
            _ = HCHelper.requestVideoChatSignature()
                .subscribe(onNext: { userSig in
                    if let sign = userSig {
                        TRTCCalling.shareInstance().login(sdkAppID: trtc_appid,
                                                          user: user.uid,
                                                          userSig: sign) {
                            PrintLog("trtc登录成功")
                        } failed: { (code, des) in
                            PrintLog("trtc登录失败: code - \(code)\ninfo\(des)")
                        }
                    }
                })
        }
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
    
    public class func pushH5(href: String, title: String? = nil) {
        PrintLog("链接跳转地址: \(href)")
        if let t = title {
            HCHelper.push(BaseWebViewController.self, ["url": href, "title": t])
        }else {
            HCHelper.push(BaseWebViewController.self, ["url": href])
        }
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
    
    /// 跳转App Store评分
    class func gotoAppstorePraise() {
        let urlStr = "http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=\(ileyun_appid)&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"
        UIApplication.shared.openURL(URL.init(string: urlStr)!)
    }
    
    /// 跳转系统设置
    class func appSetting() {
        let url = URL.init(string: UIApplication.openSettingsURLString)
        if let u = url, UIApplication.shared.canOpenURL(u) {
            UIApplication.shared.openURL(u)
        }
    }
}

//MARK: --- 视频通话相关接口
extension HCHelper {
    
    public func saveCallingUser(user: CallingUserModel?) {
        guard let callingUser = user else {
            return
        }
        
        if let _ = cachedLocalUsers.first(where: { $0.userId == callingUser.userId }) {
            PrintLog("已存在改用户信息")
        }else {
            cachedLocalUsers.append(callingUser)
        }
    }
    
    public func getCallingUser(uid: String) ->CallingUserModel? {
        return cachedLocalUsers.first(where: { $0.userId == uid })
    }
    
    /// 获取视频通话用户信息
    public static func requestVideoCallUserInfo(userId: String, consultId: String) ->Observable<CallingUserModel?> {
        if let user = HCHelper.share.getCallingUser(uid: userId) {
            return Observable.just(user)
        }else {
            if let user = HCHelper.share.userInfoModel {
                return HCProvider.request(.consultVideoUserInfo(memberId: user.uid, userId: userId, consultId: consultId))
                    .map(model: HCShortUserInfoModel.self)
                    .map{ $0.tranformUser(userId: userId) }
                    .do(onSuccess: { res in
                        HCHelper.share.saveCallingUser(user: res)
                    }, onError: { NoticesCenter.alert(message: BaseViewModel().errorMessage($0)) })
                    .asObservable()
            }else {
                NoticesCenter.alert(message: "未登陆")
                return Observable.just(nil)
            }
        }
    }
    
    /// 视频通话签名
    public static func requestVideoChatSignature() ->Observable<String?> {
        if let user = HCHelper.share.userInfoModel {
            return HCProvider.request(.videoChatSignature(memberId: user.uid))
                .mapJSON()
                .map { res -> String? in
                    if let dataDic = res as? [String : Any], let userSig = dataDic["data"] as? String {
                        return userSig
                    }else {
                        NoticesCenter.alert(message: "视频通话签名为空")
                        return nil
                    }
                }
                .do(onError: { NoticesCenter.alert(message: "视频通话签名失败：\(BaseViewModel().errorMessage($0))") })
                .catchErrorJustReturn(nil)
                .asObservable()
        }
        return Observable.just(nil)
    }
    
    /// 接听电话
    public static func requestReceivePhone(memberId: String, consultId: String) ->Observable<Bool> {
        if let user = HCHelper.share.userInfoModel {
            return HCProvider.request(.consultReceivePhone(memberId: memberId, userId: user.uid, consultId: consultId))
                .map(model: HCReceivePhoneModel.self)
                .map{ _ in true }
                .do(onError: { NoticesCenter.alert(message: "接听电话失败：\(BaseViewModel().errorMessage($0))") })
                .catchErrorJustReturn(false)
                .asObservable()
        }else {
            NoticesCenter.alert(message: "未登陆")
            return Observable.just(false)
        }
    }

    /// 拨打电话
    public static func requestStartPhone(userId: String) ->Observable<Bool> {
        if let user = HCHelper.share.userInfoModel {
            return HCProvider.request(.consultStartPhone(memberId: user.uid, userId: userId))
                .mapJSON()
                .map({ res -> Bool in
                    if let dic = res as? [String: Any],
                       let code = dic["code"] as? Int,
                       let status = RequestCode(rawValue: code) {
                        if status == .success {
                            return true
                        }else {
                            if let message = dic["message"] as? String {
                                NoticesCenter.alert(message: "拨打电话失败：\(message)")
                            }else {
                                NoticesCenter.alert(message: "拨打电话失败：未知错误")
                            }
                            return false
                        }
                    }
                    NoticesCenter.alert(message: "拨打电话失败：未知返回结果")
                    return false
                })
                .do(onError: { NoticesCenter.alert(message: "拨打电话失败：\(BaseViewModel().errorMessage($0))") })
                .catchErrorJustReturn(false)
                .asObservable()
        }else {
            NoticesCenter.alert(message: "未登陆")
            return Observable.just(false)
        }
    }

    /// 结束通话
    public static func requestEndPhone(userId: String, watchTime: String) ->Observable<Bool> {
        if let user = HCHelper.share.userInfoModel {
            return HCProvider.request(.consultEndPhone(memberId: user.uid, userId: userId, watchTime: watchTime))
                .mapJSON()
                .map({ res -> Bool in
                    if let dic = res as? [String: Any],
                       let code = dic["code"] as? Int,
                       let status = RequestCode(rawValue: code) {
                        if status == .success {
                            return true
                        }else {
                            if let message = dic["message"] as? String {
                                NoticesCenter.alert(message: "结束通话失败：\(message)")
                            }else {
                                NoticesCenter.alert(message: "结束通话失败：未知错误")
                            }
                            return false
                        }
                    }
                    NoticesCenter.alert(message: "结束通话失败：未知返回结果")
                    return false
                })
                .do(onError: { NoticesCenter.alert(message: "结束通话失败：\(BaseViewModel().errorMessage($0))") })
                .catchErrorJustReturn(false)
                .asObservable()
        }else {
            NoticesCenter.alert(message: "未登陆")
            return Observable.just(false)
        }
    }

}
