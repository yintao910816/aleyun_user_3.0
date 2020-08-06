//
//  PatientInfo.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/25.
//  Copyright © 2019 sw. All rights reserved.
//  健康档案

import Foundation

class HCHealthArchivesModel: HJModel {
    var memberInfo: HCMemberInfoModel = HCMemberInfoModel()
    var maritalHistory: HCMaritalHistoryModel = HCMaritalHistoryModel()
    var menstruationHistory: HCMenstruationHistoryModel = HCMenstruationHistoryModel()
}

class HCMemberInfoModel: HJModel {

    var id: Int = 0
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
    var unitId: Int = 0
    var sex: Int = 0
    var age: Int = 0
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
    var pregnantTypeId: String = ""
    var pregnantTypeName: String = ""
    var provinceName: String = ""
    var cityName: String = ""
    var areaCode: String = ""
    var enable: Bool = false
    var bind: Bool = false
    var soldier: Bool = false
    
    lazy var sexText: String = {
        return self.sex == 1 ? "男" : "女"
    }()
}

class HCMaritalHistoryModel: HJModel {

    var id: Int = 0
    var marReMarriage: String = ""
    var marReMarriageAge: String = ""
    var contraceptionNoPregnancyNo: String = ""
    var isPregnancy: String = ""
    var marDrugAbortion: String = ""
    var ectopicPregnancy: String = ""
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
    var memberId: Int = 0
}

class HCMenstruationHistoryModel: HJModel {

    var id: Int = 0
    var catMenarche: String = ""
    var catMensescycle: String = ""
    var catMensescycleDay: String = ""
    var catLastCatamenia: String = ""
    var catCatameniaAmount: String = ""
    var catDysmenorrhea: String = ""
    var memberId: Int = 0
    var createDate: String = ""
    var modifyDate: String = ""
    var creates: String = ""
    var modifys: String = ""
    var bak: String = ""
}
