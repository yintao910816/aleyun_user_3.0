//
//  HCFiliter.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/19.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class HCAllCityItemModel: HJModel {
    var key: String = ""
    var list: [HCCityItemModel] = []
    
    public class func creatAll() ->HCAllCityItemModel {
        let m = HCAllCityItemModel()
        m.key = "#"
        let item = HCCityItemModel()
        item.name = "全国"
        m.list.append(item)
        return m
    }
}

class HCCityItemModel: HJModel {
    var id: String = ""
    var name: String = ""
}
