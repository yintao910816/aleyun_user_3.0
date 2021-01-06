//
//  HCMessage.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCMessageItemModel: HJModel {
    var consultId: String = ""
    var code: String = ""
    var content: String = ""
    var date: String = ""
    var headPath: String = ""
    var name: String = ""
    var unReadCount: Int = 0
    var userId: String = ""
}

class HCServerMsgModel: HJModel {
    var records: [HCMessageItemModel] = []
}
