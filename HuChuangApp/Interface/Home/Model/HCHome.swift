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
    /// 为1则跳转原生界面，0跳转h5
    var primordial: Int = 0
    var recom: Int = 0
    var sort: Int = 0
    var type: String = ""
    var unitId: String = ""
    var unitName: String = ""
    
//    /// 暂时写死的菜单
//    public class func homeFuncs() ->[HCFunctionsMenuModel] {
//        let codes = ["QGH", "ZJWZ", "KSWZ", "SGBK", "SZZX", "SGRJ", "YPBK"]
//        let titles = ["去挂号", "专家问诊", "快速问诊", "试管百科", "生殖中心", "试管日记", "药品百科"]
//        let baks = ["海量生殖专家", "一对一咨询", "快问快答", "", "", "", ""]
//        let iconPaths = ["func_gh", "func_zjwz", "func_kswz", "func_sgbk", "func_szzx", "func_sgrj", "func_ypbk"]
//
//        var datas: [HCFunctionsMenuModel] = []
//        
//        for idx in 0..<codes.count {
//            let m = HCFunctionsMenuModel()
//            m.name = titles[idx]
//            m.bak = baks[idx]
//            m.code = codes[idx]
//            m.iconPath = iconPaths[idx]
//            datas.append(m)
//        }
//        return datas
//    }
}

/// 试管百科
class HCGroupCmsArticleModel: HJModel {
    var articleVoList: [HCCmsArticleListModel] = []
    var name: String = ""
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
    var id: String = ""
    var picPath: String = ""
    var readNumber: Int = 0
    var store: Int = 0
    var title: String = ""
}

//MARK: 获取的文章详情h5链接
class HCCmsDetailModel: HJModel {
    var author: String = ""
    var bak: String = ""
    var channelId: Int = 0
    var code: String = ""
    var content: String = ""
    var createDate: String = ""
    var creates: String = ""
    var del: Bool = false
    var hrefUrl: String = ""
    var id: String = ""
    var info: String = ""
    var linkTypes: Int = 1
    var linkUrls: String = ""
    var memberId: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var picPath: String = ""
    var publishDate: String = ""
    var readNumber: String = ""
    var recom: String = ""
    var release: String = ""
    var seoDescription: String = ""
    var seoKeywords: String = ""
    var shopId: String = ""
    var sort: Int = 99
    var store: Int = 0
    var storeStatus: Int = 0
    var title: String = ""
    var top: Int = 0
    var unitId: String = ""
}
