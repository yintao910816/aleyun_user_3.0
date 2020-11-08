//
//  HCTRTCCloudManager.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/6.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

public let trtc_appid: UInt32 = 1400380841
private let trtc_secretkey: String = "b6809c324ae80e2f6f2ecf54717e862979ad93bcd4c84a250f7caf00dbd8ee04"

class HCTRTCCloudManager: NSObject {
    
    private var roomId: UInt32 = 0
    private var userId: String = ""
    private var usersig: String = ""

    private let trtcCloud = TRTCCloud.sharedInstance()
    
    init(roomId: UInt32, userId: String) {
        super.init()
        self.roomId = roomId
        self.userId = userId
        hashUserSig()
        
        trtcCloud?.delegate = self
    }

    public func enterRoom() {
        let params = TRTCParams.init()
        params.sdkAppId = trtc_appid
        params.userId   = userId
        params.userSig  = usersig
        params.roomId   = roomId
        trtcCloud?.enterRoom(params, appScene: TRTCAppScene.videoCall)
    }

    public func exitRoom() {
        trtcCloud?.exitRoom()
    }
}

extension HCTRTCCloudManager {
    
    private func hashUserSig() {
        usersig = GenerateTestUserSig.genTestUserSig(userId)
    }
    
}

extension HCTRTCCloudManager: TRTCCloudDelegate {

    func onError(_ errCode: TXLiteAVError, errMsg: String?, extInfo: [AnyHashable : Any]?) {
        if ERR_ROOM_ENTER_FAIL == errCode {
            NoticesCenter.alert(message: "进房失败[\(errMsg ?? "")]")
            exitRoom()
        }
    }
    
    func onEnterRoom(_ result: Int) {
        if result > 0 {
            PrintLog("进房成功，总计耗时[\(result)]ms")
        } else {
            NoticesCenter.alert(message: "进房失败，错误码[\(result)]")
        }
    }

    func onExitRoom(_ reason: Int) {
        PrintLog("离开房间[\(roomId)]: reason[\(reason)]")
    }
}
