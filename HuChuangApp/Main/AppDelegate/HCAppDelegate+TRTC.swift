//
//  HCAppDelegate+TRTC.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/6.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

extension HCAppDelegate: TRTCCallingDelegate {

    public func setupTRTC() {
        TRTCCalling.shareInstance().addDelegate(self)
        V2TIMManager.sharedInstance()?.setAPNSListener(self)
        
        #if DEBUG
        TRTCCloud.setConsoleEnabled(true)
        #endif
    }
    
    // 被邀请通话
    func onInvited(sponsor: String, userIds: [String], isFromGroup: Bool, callType: CallType) {
        HCSystemAudioPlay.share.videoCallPlay()
        _ = HCHelper.requestVideoCallUserInfo(userId: sponsor, consultId: "\(TRTCCalling.shareInstance().curRoomID)")
            .subscribe(onNext: {
                let callVC = HCConsultVideoCallController(sponsor: $0)
                
                callVC.dismissBlock = { }
                
                callVC.modalPresentationStyle = .fullScreen
                callVC.resetWithUserList(users: [$0], isInit: true)
                NSObject().visibleViewController?.present(callVC, animated: true, completion: nil)
                
                print("\($0.name) 邀请你通话")
            })
    }
    
    // 进入通话回调
    func onUserEnter(uid: String) {
        
        _ = Observable.combineLatest(HCHelper.requestVideoCallUserInfo(userId: uid,
                                                                   consultId: "\(TRTCCalling.shareInstance().curRoomID)"),
                                 HCHelper.requestReceivePhone(userId: uid,
                                                              consultId: "\(TRTCCalling.shareInstance().curRoomID)"))
            .subscribe(onNext: {
                NotificationCenter.default.post(name: NotificationName.ChatCall.userEnter, object: $0)
            })
    }
    
    // 离开通话回调
    func onUserLeave(uid: String) {
        var text = "已挂断"
        if let user = HCHelper.share.getCallingUser(uid: uid) {
            text = "\(user.name) 已挂断"
            PrintLog(text)
        }
        NotificationCenter.default.post(name: NotificationName.ChatCall.otherLeave, object: text)        
    }
    
    // 拒绝通话回调-仅邀请者受到通知,其他用户应使用
    func onReject(uid: String) {
        var text = "已拒绝"
        if let user = HCHelper.share.getCallingUser(uid: uid) {
            text = "\(user.name) 已拒绝"
            PrintLog(text)
        }

        NotificationCenter.default.post(name: NotificationName.ChatCall.otherReject, object: text)
    }
    
    // 无回应回调-仅邀请者受到通知，其他用户应使用
    func onNoResp(uid: String) {
        var text = "无响应"
        if let user = HCHelper.share.getCallingUser(uid: uid) {
            text = "\(user.name) 无响应"
            PrintLog(text)
        }

        NotificationCenter.default.post(name: NotificationName.ChatCall.error, object: text)
    }
            
    // 通话占线回调-仅邀请者受到通知，其他用户应使用
    func onLineBusy(uid: String) {
        var text = "通话占线"
        if let user = HCHelper.share.getCallingUser(uid: uid) {
            text = "\(user.name) 通话占线"
            PrintLog(text)
        }

        NotificationCenter.default.post(name: NotificationName.ChatCall.error, object: text)
    }
    
    // 当前通话被取消回调
    func onCallingCancel(uid: String) {
        var text = "已取消"
        if let user = HCHelper.share.getCallingUser(uid: uid) {
            text = "\(user.name) 已取消"
            PrintLog(text)
        }

        NotificationCenter.default.post(name: NotificationName.ChatCall.cancel, object: text)
    }
    
    // 通话超时的回调
    func onCallingTimeOut() {
        PrintLog("通话超时")
        NotificationCenter.default.post(name: NotificationName.ChatCall.error, object: "超时")
    }

    // 通话结束
    func onCallEnd() {
        print("通话结束")
    }
    
    func onError(code: Int32, msg: String?) {
        NotificationCenter.default.post(name: NotificationName.ChatCall.error, object: "内部错误：\(code) -- \(msg ?? "")")
    }
}

extension HCAppDelegate: V2TIMAPNSListener {
    
    func onSetAPPUnreadCount() -> UInt32 {
        return 0
    }
    
}
