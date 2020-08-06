//
//  HCSearch.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/3.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class HCSearchDataModel: HCBaseSearchItemModel {
    var doctor: [HCSearchDoctorItemModel] = []
    var article: [HCSearchArticleItemModel] = []
    var course: [HCSearchCourseItemModel] = []
}

class HCSearchDoctorModel: HCBaseSearchItemModel {
    var records: [HCSearchDoctorItemModel] = []
}

class HCSearchDoctorItemModel : HCBaseSearchItemModel {
    var attention: String = ""
    var brief: String = ""
    var consultNumber: Int = 0
    var consultReplyNumber: Int = 0
    var headPath: String = ""
    var memberId: Int = 0
    var practitionerNumber: Int = 0
    var practitionerYear: String = ""
    var price: String = ""
    var reviewNum: Int = 0
    var skilledIn: String = ""
    var technicalPost: String = ""
    var unitId: Int = 0
    var unitName: String = ""
    var userId: Int = 0
    var userName: String = ""

    /// 展示价格
    lazy var priceAttText: NSAttributedString = {
        return "¥\(self.price)".attributed(NSMakeRange(0, 1), HC_MAIN_COLOR, .font(fontSize: 10, fontName: .PingFSemibold))
    }()
}

class HCSearchArticleModel: HCBaseSearchItemModel {
    var records: [HCSearchArticleItemModel] = []
}

class HCSearchArticleItemModel: HCBaseSearchItemModel {
    var author: String = ""
    var bak: String = ""
    var channelId: Int = 0
    var code: String = ""
    var content: String = ""
    var createDate: String = ""
    var creates: String = ""
    var del: Bool = false
    var hrefUrl: String = ""
    var id: Int = 0;
    var info: String = ""
    var linkTypes: Int = 0
    var linkUrls: String = ""
    var memberId: Int = 0
    var modifyDate: String = ""
    var modifys: String = ""
    var picPath: String = ""
    var publishDate: String = ""
    var readNumber: Int = 0
    var recom: Int = 0
    var release: Bool = true
    var seoDescription: String = ""
    var seoKeywords: String = ""
    var shopId: Int = 0
    var sort: Int = 0
    var store: Int = 0
    var title: String = ""
    var top: Bool = true
    var unitId: Int = 0
    
    lazy var readCountText: String = {
        return "\(self.readNumber) 阅读"
    }()
    
    lazy var collectCountText: String = {
        return "\(self.store) 收藏"
    }()
}

class HCSearchCourseModel: HCBaseSearchItemModel {
    var records: [HCBaseSearchItemModel] = []
}

class HCSearchCourseItemModel: HCBaseSearchItemModel {
    
}

class HCBaseSearchItemModel: HJModel {
    
}
