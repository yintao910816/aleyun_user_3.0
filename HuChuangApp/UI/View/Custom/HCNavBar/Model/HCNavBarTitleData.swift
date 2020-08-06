//
//  HCNavBarTitleData.swift
//  HuChuangApp
//
//  Created by yintao on 2020/7/21.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

enum HCNavBarTitleMode {
    case orderRecord
}

class HCNavBarOrderRecordModel {
    
    public var isSelected: Bool = false
    public var title: String = ""
    
    static func createDatas() ->[HCNavBarOrderRecordModel] {
        var datas: [HCNavBarOrderRecordModel] = []
        var titles: [String] = ["全部", "单次图文", "聊天咨询", "视频咨询"]
        for idx in 0..<titles.count {
            let m = HCNavBarOrderRecordModel()
            m.title = titles[idx]
            m.isSelected = idx == 0
            datas.append(m)
        }
        
        return datas
    }
}
