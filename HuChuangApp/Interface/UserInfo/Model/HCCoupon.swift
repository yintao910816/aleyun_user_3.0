//
//  HCCoupon.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/21.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCCouponModel: HJModel {
    var name: String = "￥8抵扣券"
    var payPrice: String = ""
    var code: String = ""
    var sn: String = ""
    var lines: String = ""
    var scenarioCode: String = ""
    var scenarioName: String = "抵扣券"
    var expirDate: String = "过期时间"
    var remainDays: String = ""
    var consume: String = ""
    var status: Int = 1
    var discountType: Int = 1
    var content: String = "用于精准预约咨询"
    var bak: String = "试试试试试试"
    
    public var attributeName: NSAttributedString {
        get {
            let string = NSMutableAttributedString.init(string: name)
            string.addAttribute(NSAttributedString.Key.font, value: UIFont.font(fontSize: 15), range: .init(location: 0, length: 1))
            return string
        }
    }
    
    public var remainDaysText: String {
        get {
            return "还剩\(remainDays)天到期"
        }
    }
}

/**
 "name": "￥8抵扣券",
 "payPrice": null,
 "code": null,
 "sn": "zx1234567890",
 "lines": 0.01000000000000000020816681711721685132943093776702880859375,
 "scenarioCode": "consult",
 "scenarioName": "抵扣券",
 "expirDate": null,
 "remainDays": 9,
 "consume": 0.01000000000000000020816681711721685132943093776702880859375,
 "status": 1,
 "discountType": 1,
 "content": "满42元使用",
 "bak": "仅用于图文和视频咨询"
 */
