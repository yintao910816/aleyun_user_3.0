//
//  HCAppDelegate+TRTC.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/6.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

extension HCAppDelegate: TRTCCallingDelegate {

    // 被邀请通话
    func onInvited(sponsor: String, userIds: [String], isFromGroup: Bool, callType: CallType) {
        HCSystemAudioPlay.share.videoCallPlay()
        _ = HCHelper.requestVideoCallUserInfo(userId: sponsor, consultId: "\(TRTCCalling.shareInstance().curRoomID)")
            .subscribe(onNext: {
                if let callingUser = $0 {
                    let callVC = HCConsultVideoCallController(sponsor: callingUser)
                    
                    callVC.dismissBlock = { }
                    
                    callVC.modalPresentationStyle = .fullScreen
                    callVC.resetWithUserList(users: [callingUser], isInit: true)
                    NSObject().visibleViewController?.present(callVC, animated: true, completion: nil)
                    
                    print("\(callingUser.name) 邀请你通话")
                }
            })
    }
    
    // 进入通话回调
    func onUserEnter(uid: String) {
        _ = HCHelper.requestVideoCallUserInfo(userId: uid, consultId: "\(TRTCCalling.shareInstance().curRoomID)")
            .subscribe(onNext: { user in
                if let callingUser = user {
                    NotificationCenter.default.post(name: NotificationName.ChatCall.videoCallAccept, object: callingUser)
                    
                    print("\(callingUser.name) 进入通话")
                }
            })
        
        _ = HCHelper.requestReceivePhone(memberId: uid, consultId: "\(TRTCCalling.shareInstance().curRoomID)")
            .subscribe(onNext: { _ in })
    }
    
    // 离开通话回调
    func onUserLeave(uid: String) {
        print("离开通话")
        NotificationCenter.default.post(name: NotificationName.ChatCall.otherLeaveVideoCall, object: nil)
        _ = HCHelper.requestEndPhone(userId: uid, watchTime: "100")
            .subscribe(onNext:{ _ in })
    }
    
    // 拒绝通话回调-仅邀请者受到通知,其他用户应使用
    func onReject(uid: String) {
        print("拒绝通话")
        NotificationCenter.default.post(name: NotificationName.ChatCall.otherRejectVideoCall, object: nil)
    }
    
    // 无回应回调-仅邀请者受到通知，其他用户应使用
    func onNoResp(uid: String) {
        print("通话无回应")
        NotificationCenter.default.post(name: NotificationName.ChatCall.onLineBusyVideoCall, object: nil)
    }
            
    // 通话占线回调-仅邀请者受到通知，其他用户应使用
    func onLineBusy(uid: String) {
        print("通话占线")
        NotificationCenter.default.post(name: NotificationName.ChatCall.onLineBusyVideoCall, object: nil)
    }
    
    // 当前通话被取消回调
    func onCallingCancel(uid: String) {
        print("当前通话被取消")
        NotificationCenter.default.post(name: NotificationName.ChatCall.otherRejectVideoCall, object: nil)
    }
    
    // 通话超时的回调
    func onCallingTimeOut() {
        print("通话超时")
        NotificationCenter.default.post(name: NotificationName.ChatCall.onLineBusyVideoCall, object: nil)
    }

    // 通话结束
    func onCallEnd() {
        print("通话结束")
    }
}
