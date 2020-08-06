//
//  HCUser.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import HandyJSON

class HCUserModel: HJModel {
    
    var uid: String = ""
    var account: String = ""
    var name: String = ""
    var realName: String = ""
    var email: String = ""
    var lastLogin: String = ""
    var ip: String = ""
    var status: Bool = true
    var bak: String = ""
    var skin: String = ""
    var numbers: String = ""
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var unitId: String = ""
    var sex: Int = 0
    var age: String = ""
    var birthday: String = ""
    var token: String = ""
    var headPath: String = ""
    var environment: String = ""
    var synopsis: String = ""
    var bindDate: String = ""
    var mobileInfo: String = ""
    var unitName: String = ""
    var visitCard: String = ""
    var identityCard: String = ""
    var hisNo: String = ""
    var medicalRecordNo: String = ""
    var medicalRecordType: String = ""
    var medicalRecordName: String = ""
    var certificateType: String = ""
    var mobileView: String = ""
    var black: String = ""
    var senior: String = ""
    var pregnantTypeId: Int = 0
    /// 备孕状态
    var pregnantTypeName: String = ""
    var enable: Bool = false
    var bind: Bool = false
    var soldier: Bool = false
    var cityName: String = ""
    var areaCode: String = ""
    
    var sexText: String {
        get { return sex == 1 ? "男" : "女" }
    }
    
    /// 是否绑定成功
    var isSuccessBind: Bool {
        get { return visitCard.count > 0 }
    }
        
    override func mapping(mapper: HelpingMapper) {
        mapper.specify(property: &uid, name: "id")
    }
    
}
