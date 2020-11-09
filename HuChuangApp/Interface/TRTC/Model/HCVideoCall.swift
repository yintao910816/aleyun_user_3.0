//
//  HCVideoCall.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/9.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCShortUserInfoModel: HJModel {
    var memberHeadPath = ""
    var memberName = ""
    var userHeadPath = ""
    var userName = ""
    
    public func tranformUser(memberId: String) ->CallingUserModel {
        var curUser = CallingUserModel()
        curUser.name = memberName
        curUser.avatarUrl = userHeadPath
        curUser.userId = memberId
        curUser.isVideoAvaliable = true
        curUser.isEnter = true
        return curUser
    }
}

class HCReceivePhoneModel: HJModel {
    var apm = ""
    var consultId = ""
    var createDate = ""
    var creates = ""
    var endTime = ""
    var id = 1
    var modifyDate = ""
    var modifys = ""
    var startTime = ""
    var subjectDate = ""
    var subjectTimeId = ""
    var timeLength = ""
    var userId = ""
}
