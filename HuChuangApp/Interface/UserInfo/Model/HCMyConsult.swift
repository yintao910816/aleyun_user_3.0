//
//  HCMyConsult.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/22.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

/// 图文咨询
class HCPicConsultListModel: HJModel {
    var records: [HCPicConsultItemModel] = []
}

class HCPicConsultItemModel: HJModel, HCConsultModelAdapt {
    var appointTimeDesc: String = ""
    var consultId: String = ""
    var consultTypeName: String = ""
    var content: String = ""
    var createDate: String = ""
    var headPath: String = ""
    var orderSn: String = ""
    var status: Int = 0
    var technicalPost: String = ""
    var userId: String = ""
    var userName: String = ""
}

/// 视频问诊
class HCVideoConsultListModel: HJModel {
    var records: [HCVideoConsultItemModel] = []
}

class HCVideoConsultItemModel: HJModel, HCConsultModelAdapt {

}

/// 云门诊
class HCCloudClinicConsultListModel: HJModel {
    var records: [HCCloudClinicConsultItemModel] = []
}

class HCCloudClinicConsultItemModel: HJModel, HCConsultModelAdapt {

}

protocol HCConsultModelAdapt {
    
}
