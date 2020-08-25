//
//  TYFiliterViewData.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/19.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class HCListFilterModel {
    
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

class HCListFilterSectionModel {
    
    public var sectionTitle: String = ""

    public var datas: [HCListFilterModel] = []
    
}

extension HCListFilterSectionModel {
    
    /// 专家问诊列表 - 排序方式筛选
    public class func createExpertConsultationSortedData() ->[HCListFilterSectionModel] {
        let titles_1 = ["默认排序", "问诊数", "好评率"]

        let section_1 = HCListFilterSectionModel()
        for item in titles_1 {
            let m = HCListFilterModel()
            m.title = item
            section_1.datas.append(m)
        }
        
        return [section_1]
    }

    /// 专家问诊列表 - 咨询方式筛选
    public class func createExpertConsultationTypeData() ->[HCListFilterSectionModel] {
        let titles_1 = ["图文", "视频"]

        let section_1 = HCListFilterSectionModel()
        for item in titles_1 {
            let m = HCListFilterModel()
            m.title = item
            section_1.datas.append(m)
        }
        
        return [section_1]
    }

}
