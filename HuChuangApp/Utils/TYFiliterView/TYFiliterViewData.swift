//
//  TYFiliterViewData.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/19.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class TYFiliterModel {
    
    public var title: String = ""
    public var normalBGColor: UIColor = RGB(246, 246, 246)
    public var selectedBGColor: UIColor = RGB(255, 228, 233)
    public var normalTextColor: UIColor = RGB(61, 55, 68)
    public var selectedTextColor: UIColor = HC_MAIN_COLOR
    
    public var isSelected: Bool = false

    init() { }
        
    public var contentSize: CGSize {
        get {
            let w = title.getTexWidth(fontSize: 12, height: 30, fontName: FontName.PingFMedium.rawValue) + 30
            return .init(width: w, height: 30)
        }
    }
    
    public var bgColor: UIColor {
        get {
            return isSelected ? selectedBGColor : normalBGColor
        }
    }
    
    public var titleColor: UIColor {
        get {
            return isSelected ? selectedTextColor : normalTextColor
        }
    }
}

class TYFiliterSectionModel {
    
    public var sectionTitle: String = ""

    public var datas: [TYFiliterModel] = []
    
    public class func createData() ->[TYFiliterSectionModel] {
        let titles_1 = ["主任医师", "副主任医师", "主治医师"]
        let titles_2 = ["加号"]
        let titles_3 = ["人工授精", "试管婴儿", "输卵管堵塞", "卵巢早衰", "排卵障碍", "多囊卵巢", "促排卵治疗", "子宫内膜异常", "习惯性流产"]

        let section_1 = TYFiliterSectionModel()
        section_1.sectionTitle = "医生级别"
        for item in titles_1 {
            let m = TYFiliterModel()
            m.title = item
            section_1.datas.append(m)
        }
        
        let section_2 = TYFiliterSectionModel()
        section_2.sectionTitle = "加号"
        for item in titles_2 {
            let m = TYFiliterModel()
            m.title = item
            section_2.datas.append(m)
        }

        let section_3 = TYFiliterSectionModel()
        section_3.sectionTitle = "擅长类目"
        for item in titles_3 {
            let m = TYFiliterModel()
            m.title = item
            section_3.datas.append(m)
        }
        
        return [section_1, section_2, section_3]
    }
}
