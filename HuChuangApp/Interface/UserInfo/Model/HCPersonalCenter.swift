//
//  HCPersonalCenter.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCPersonalCenterInfoModel: HJModel {
    /// 收藏数量
    var attentionStore: Int = 0
    /// 优惠卷数量
    var coupon: Int = 0
    /// 服务包数量
    var servicePack: Int = 0
    
    var healthArchives: HCPersonalHealthArchivesModel?
    var progressServices: [HCPersonalProgressServiceModel] = []
}

class HCPersonalHealthArchivesModel: HJModel {
    var memberName: String = "张三"
    var age: String = "25"
    var sex: Int = 0
}

class HCPersonalProgressServiceModel: HJModel {
    var headPath: String = ""
    var serverType: Int = 0
    var technicalPost: String = ""
    var unitName: String = ""
    var userId: String = ""
    var userName: String = ""
}
