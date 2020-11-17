//
//  HCAttentionStore.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/21.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

/// 列表类型
enum HCMenuListModuleType: String {
    /// 我的医生
    case doctor = "doctor"
    /// 我的课程
    case course = "course"
    /// 我的资讯
    case information = "information"
}

//MARK: 收藏的医生
class HCCollectionDoctorData: HJModel {
    var records: [HCDoctorListItemModel] = []
}

//class HCCollectionDoctorModel: HJModel {
//    var id: String = ""
//    var account: String = ""
//    var name: String = ""
//    var email: String = ""
//    var mobile: String = ""
//    var lastLogin: String = ""
//    var ip: String = ""
//    var status: String = ""
//    var bak: String = ""
//    var skin: String = ""
//    var numbers: String = ""
//    var unitId: String = ""
//    var unitName: String = ""
//    var createDate: String = ""
//    var modifyDate: String = ""
//    var creates: String = ""
//    var modifys: String = ""
//    var age: String = ""
//    var sex: String = ""
//    var birthday: String = ""
//    var token: String = ""
//    var headPath: String = ""
//    var sort: String = ""
//    var brief: String = ""
//    var environment: String = ""
//    var spellCode: String = ""
//    var spellBrevityCode: String = ""
//    var wubiCode: String = ""
//    var skilledIn: String = ""
//    var skilledInIds: String = ""
//    var technicalPost: String = ""
//    var technicalPostId: String = ""
//    var hisNo: String = ""
//    var hisCode: String = ""
//    var linueupNo: String = ""
//    var departmentId: String = ""
//    var consult: String = ""
//    var consultPrice: String = ""
//    var smsNotice: String = ""
//    var practitionerYear: String = ""
//    var provinceName: String = ""
//    var cityName: String = ""
//    var areaCode: String = ""
//    var viewProfile: String = ""
//    var departmentName: String = ""
//    var consultNum: String = ""
//    var replyNum: String = ""
//    var prasiRat: String = ""
//    var respRate: String = ""
//    var levelName: String = ""
//    var identity: String = ""
//    var hospitalName: String = ""
//    var centerFlag: String = ""
//    var rejectContent: String = ""
//    var currentMonthPrice: String = ""
//    var allWithdrawalMoney: String = ""
//    var minPrice: String = ""
//    var consultProject: String = ""
//    var recom: String = ""
//    var enable: String = ""
//}

//MARK: 收藏的课程
class HCCollectionCourseData: HJModel {
    var records: [HCCollectionCourseModel] = []
}

class HCCollectionCourseModel: HJModel {
    
}

//MARK: 收藏的资讯
class HCCollectionInformationData: HJModel {
    var records: [HCCmsArticleListModel] = []
}
