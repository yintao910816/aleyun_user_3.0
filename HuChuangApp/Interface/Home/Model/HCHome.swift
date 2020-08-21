//
//  HCHome.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/18.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

/// 功能按钮
class HCFunctionsMenuModel: HJModel {
    var bak: String = ""
    var bind: String = ""
    var code: String = ""
    var createDate: String = ""
    var creates: String = ""
    var functionUrl: String = ""
    var hide: Bool = false
    var iconPath: String = ""
    var id: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var name: String = ""
    var primordial: String = ""
    var recom: Int = 0
    var sort: Int = 0
    var type: String = ""
    var unitId: String = ""
    var unitName: String = ""
}

/// 文章栏目菜单
class HCCmsCmsChanelListModel: HJModel {
    var bak: String = ""
    var code: String = ""
    var createDate: String = ""
    var creates: String = ""
    var del: Bool = false
    var hide: Bool = false
    var id: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var name: String = ""
    var parentId: String = ""
    var path: String = ""
    var platform: String = ""
    var recom: Int = 0
    var shopId: String = ""
    var sort: String = ""
    var target: String = ""
    var type: String = ""
    var unitId: String = ""
    var url: String = ""
}

class HCCmsRecommendModel: HJModel {
    var id: String = ""
    var picPath: String = ""
    var title: String = ""
    
    public lazy var itemW: CGFloat = {
        let titleW: CGFloat = self.title.ty_textSize(font: .font(fontSize: 14), width: CGFloat(MAXFLOAT), height: 20).width
        return titleW + 5
    }()
}

class HCCmsArticleListModel: HJModel {
    
}
