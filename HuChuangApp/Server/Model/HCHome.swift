//
//  HCHome.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/2.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

/// 孕柚课堂
struct HCHomePregnancyClassroomMenuModel {
    var title: String = ""
    var font: UIFont = .font(fontSize: 11)
    
    var textColor: UIColor = RGB(51, 51, 51)
    var selectedTextColor: UIColor = .white
    
    var backGroundColor: UIColor = RGB(245, 245, 245)
    var selectedBackGroudColor: UIColor = RGB(255, 102, 149)
    
    var isSelected: Bool = false
    
    /// 对应menu选项的封面信息
//    var coverData: 
    
    lazy var itemSize: CGSize = {
        let width = self.title.getTexWidth(fontSize: 11, height: 23, fontName: FontName.PingFRegular.rawValue) + 30
        return .init(width: width, height: 23)
    }()
    
    static func creatTestData() ->[HCHomePregnancyClassroomMenuModel] {
        var datas = [HCHomePregnancyClassroomMenuModel]()
        let titles = ["全部", "备孕必修", "喜传好孕", "试管婴儿", "备孕必修", "喜传好孕", "试管婴儿"]
        for idx in 0..<titles.count {
            let m = HCHomePregnancyClassroomMenuModel(title: titles[idx], isSelected: idx == 0)
            datas.append(m)
        }
        return datas
    }
}
