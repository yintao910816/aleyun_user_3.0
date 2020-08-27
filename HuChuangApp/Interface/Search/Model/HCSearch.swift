//
//  HCSearch.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/27.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCDoctorListModel: HJModel {
    var records: [HCDoctorListItemModel] = []
}

/// 资讯
class HCRealTimeListModel: HJModel {
    var records: [HCRealTimeListItemModel] = []
}

class HCRealTimeListItemModel: HJModel, HCSearchDataProtocol {
    var id: String = ""
    var picPath: String = ""
    var readNumber: String = ""
    var store: String = ""
    var title: String = ""
}

/// 课程
class HCCourseListModel: HJModel {
    var records: [HCCourseListItemModel] = []
}

class HCCourseListItemModel: HJModel, HCSearchDataProtocol {
    var courseId: String = ""
    var coverPic: String = ""
    var readNum: String = ""
    var storeNum: String = ""
    var title: String = ""
}

/// 直播
class HCLiveVideoListModel: HJModel {
    var records: [HCLiveVideoListItemModel] = []
}

class HCLiveVideoListItemModel: HJModel, HCSearchDataProtocol {
    
}

protocol HCSearchDataProtocol {
    
}
