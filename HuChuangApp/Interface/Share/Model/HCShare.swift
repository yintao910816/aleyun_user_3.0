//
//  HCArticle.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

enum HCShareMode {
    case article
    case doctor
}

class HCShareDataModel {
    var id: String = ""
    var title: String = ""
    var picPath: String = ""
    /// 分享链接
    var link: String = ""
    /// web链接
    var href: String = ""
    
    /// 医生id
    var userId: String = ""
    /// 用户id
    var memberId: String = ""
}

extension HCShareDataModel {
    /// cms文章详情model转分享模型
    public static func transformCmsModel(model: HCCmsDetailModel) ->HCShareDataModel {
        let m = HCShareDataModel()
        m.id = model.id
        m.title = model.title
        m.picPath = model.picPath
        m.link = model.hrefUrl
        m.href = model.hrefUrl
        return m
    }
    
    /// 医生model转分享模型
    public static func transformDoctorModel(model: HCDoctorListItemModel) ->HCShareDataModel {
        let url = APIAssistance.consultationHome(with: model.id, unitId: model.unitId)

        let m = HCShareDataModel()
        m.title = model.name
        m.picPath = model.headPath
        m.link = url
        m.href = url
        m.userId = model.id
        m.memberId = HCHelper.share.userInfoModel?.uid ?? ""
        return m
    }
    
    /// 精准预约医生主页
    public static func transformAccurateConsultModel(model: HCAccurateConsultItemModel) ->HCShareDataModel {
        let url = APIAssistance.consultationHome(with: model.userId, unitId: "")

        let m = HCShareDataModel()
        m.title = model.userName
        m.picPath = model.headPath
        m.link = url
        m.href = url
        m.userId = model.userId
        m.memberId = HCHelper.share.userInfoModel?.uid ?? ""
        return m
    }
}

class HCStoreAndStatusModel: HJModel {
    var store: Int = 0
    var status: Bool = false
}
