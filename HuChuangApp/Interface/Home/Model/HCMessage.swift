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
    var content: String = "答复哈都是废话看哈电视立刻恢复健康哈速度快哈瞌睡的很疯狂啊数据恢复快乐啊速度很快"
    var date: String = "2020-11-10 11:11"
    var headPath: String = ""
    var name: String = "放大舒服阿斯顿发阿斯顿发阿斯顿发大发"
    var unReadCount: Int = 0
    var userId: String = ""
}

class HCServerMsgModel: HJModel {
    var records: [HCMessageItemModel] = []
}
