//
//  HCMyConsult.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/22.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

/// 订单状态
enum HCOrderDetailStatus: Int {
    /// 未知状态
    case unknow = -1
    /// 待支付
    case unpay = 0
    /// 已取消 - 订单状态 status
    case cancelled = 7
    /// 已完成 - 已支付，已回复，已完结
    case finished = 8
    /// 接诊中 - 组合状态（已支付，已回复，未完结）
    case receiving = 9
    /// 待接诊 - 已支付，未回复
    case waiteReceive = 10
    
    /// 我的问诊支付状态
    public var myConsultPayStatusText: String {
        switch self {
        case .unpay:
            return "待支付"
        case .cancelled:
            return "已取消"
        case .finished:
            return "已完成"
        case .receiving:
            return "接诊中"
        case .waiteReceive:
            return "待接诊"
        case .unknow:
            return "未知状态"
        }
    }

    /// 我的问诊按钮文字
    public var myConsultButtonText: String {
        switch self {
        case .unpay:
            return "去支付"
        case .cancelled:
            return "再次咨询"
        case .finished:
            return "再次咨询"
        case .receiving:
            return "进入咨询"
        case .waiteReceive:
            return "进入咨询"
        case .unknow:
            return "未知状态"
        }
    }
}


/// 图文咨询
class HCPicConsultListModel: HJModel {
    var records: [HCConsultItemModel] = []
}

class HCConsultItemModel: HJModel, HCConsultModelAdapt {
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
    var consultType: String = ""
    var subjectDate: String = ""
    var apm: String = ""
    var address: String = ""
    var week: String = ""

    public lazy var nameText: NSAttributedString = {
        let string = NSMutableAttributedString(string: "\(self.userName) \(self.technicalPost)")
        string.addAttribute(NSAttributedString.Key.font,
                            value: UIFont.font(fontSize: 14),
                            range: .init(location: self.userName.count + 1, length: self.technicalPost.count))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value: RGB(153, 153, 153),
                            range: .init(location: self.userName.count + 1, length: self.technicalPost.count))
        return string
    }()
    
    public lazy var timeText: String = {
        return "\(self.createDate) \(self.consultTypeName)"
    }()

    public lazy var statusMode: HCOrderDetailStatus = {
        if let statusMode = HCOrderDetailStatus(rawValue: self.status) {
            return statusMode
        }
        return .unknow
    }()
    
}

/// 视频问诊
class HCVideoConsultListModel: HJModel {
    var records: [HCConsultItemModel] = []
}

/// 云门诊
class HCCloudClinicConsultListModel: HJModel {
    var records: [HCCloudClinicConsultItemModel] = []
}

class HCCloudClinicConsultItemModel: HJModel, HCConsultModelAdapt {

}

protocol HCConsultModelAdapt {
    
}

//MARK: 精准预约
class HCAccurateConsultModel: HJModel {
    var records: [HCAccurateConsultItemModel] = []
}

class HCAccurateConsultItemModel: HJModel {
    var address: String = ""
    var apm: String = ""
    var appointTimeDesc: String = ""
    var consultId: String = ""
    var consultType: Int = 4
    var consultTypeName: String = ""
    var content: String = ""
    var createDate: String = ""
    var headPath: String = ""
    var orderSn: String = ""
    var status: Int = 9
    var subjectDate: String = ""
    var  technicalPost: String = ""
    var userId: String = ""
    var userName: String = ""
    var week: String = ""
    
    public lazy var nameText: NSAttributedString = {
        let string = NSMutableAttributedString(string: "\(self.userName) \(self.technicalPost)")
        string.addAttribute(NSAttributedString.Key.font,
                            value: UIFont.font(fontSize: 14),
                            range: .init(location: self.userName.count + 1, length: self.technicalPost.count))
        string.addAttribute(NSAttributedString.Key.foregroundColor, value: RGB(153, 153, 153),
                            range: .init(location: self.userName.count + 1, length: self.technicalPost.count))
        return string
    }()
    
    public lazy var createTimeText: String = {
        return "\(self.createDate) \(self.consultTypeName)"
    }()

    public lazy var timeText: NSAttributedString = {
        let text = "预约时间   \(subjectDate) \(week)(\(apm == "AM" ? "上午" : "下午"))"
        return text.attributed(.init(location: 4, length: text.count - 4), RGB(51, 51, 51), .font(fontSize: 14))
    }()

    public lazy var addressText: NSAttributedString = {
        let text = "预约地点   \(address)"
        return text.attributed(.init(location: 4, length: text.count - 4), RGB(51, 51, 51), .font(fontSize: 14))
    }()

    public lazy var statusMode: HCOrderDetailStatus = {
        if let statusMode = HCOrderDetailStatus(rawValue: self.status) {
            return statusMode
        }
        return .unknow
    }()
}
