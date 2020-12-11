//
//  HCTool.swift
//  HuChuangApp
//
//  Created by yintao on 2020/12/4.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

enum HCYJRemindMode {
    /// 月经走了
    case going
    /// 月经来了
    case coming
    /// 把月经开始时间提前，这里需要提示
    case early
    /// 之前的周期取消月经走了，不允许操作，弹提示
    case cancelGoingForbiden
    /// 两次月经间隔必须大于5天
    case forbidenGoing
    case forbidenComming

    public var titleText: String {
        get {
            switch self {
            case .going, .cancelGoingForbiden:
                return "大姨妈走了"
            case .coming, .early:
                return "大姨妈来了"
            case .forbidenComming:
                return "大姨妈来了"
            case .forbidenGoing:
                return "大姨妈走了"
            }
        }
    }
    
    public func remindText(dayItem: TYCalendarItem) ->String? {
        switch self {
        case .going, .coming:
            return nil
        case .early:
            return HCToolCalculate.earlyMensturaRemindText(newDateS: dayItem.dateText,
                                                           dateS: dayItem.belongMenstruaModel?.menstruationDate ?? "")
        case .cancelGoingForbiden:
            return HCToolCalculate.cancelGoingForbidenRemindText()
        case .forbidenComming, .forbidenGoing:
            return "两次月经间隔必须大于5天"
        }
    }
}

enum HCMenstruationMode {
    ///
    case none
    /// 月经期
    case yjq
    /// 安全期
    case aqq
    /// 排卵期
    case plq
    /// 排卵日
    case plr
    
    public var color: UIColor {
        get {
            switch self {
            case .none:
                return RGB(161, 161, 161)
            case .yjq:
                return .white
            case .aqq:
                return RGB(109, 206, 111)
            case .plq, .plr:
                return RGB(195, 172, 230)
            }
        }
    }
    
}

class HCMensturaDateInfo: NSObject {
    public var date: Date = Date()
    public var mensturationMode: HCMenstruationMode = .none
    public var topRightIcon: UIImage?
    public var bottomLeftIcon: UIImage?
    public var bottomRightIcon: UIImage?
    
    public class func transform(dates: [Date], mensturationMode: HCMenstruationMode) ->[HCMensturaDateInfo] {
        var datas: [HCMensturaDateInfo] = []
        
        for idx in 0..<dates.count {
            let dateInfo = HCMensturaDateInfo()
            dateInfo.mensturationMode = mensturationMode
            dateInfo.date = dates[idx]
            
            if mensturationMode == .yjq {
                dateInfo.bottomLeftIcon = idx == 0 ? UIImage(named: "yjq_start") : idx == dates.count - 1 ? UIImage(named: "yjq_end") : nil
            }else if mensturationMode == .plr {
                dateInfo.bottomLeftIcon = UIImage(named: "tool_painuanri")
            }
            datas.append(dateInfo)
        }
        return datas
    }
    
    public class func transform(date: Date, mensturationMode: HCMenstruationMode) ->HCMensturaDateInfo {
        let dateInfo = HCMensturaDateInfo()
        dateInfo.mensturationMode = mensturationMode
        dateInfo.date = date
        
        if mensturationMode == .plr {
            dateInfo.bottomLeftIcon = UIImage(named: "tool_painuanri")
        }
        return dateInfo
    }

}


class HCBaseInfoDataModel: HJModel {
    var baseInfo: [HCBaseInfoItemModel] = []
    var menstruationList: [[HCMenstruationModel]] = []    
}

class HCBaseInfoItemModel: HJModel {
    var knew: Bool = false
    var menstruationEnd: Bool = false
    var menstruationStart: Bool = false
    var stature: String = ""
    var temperature: String = ""
    var type: Int = 0
    var weight: String = ""
    
    public var isMark: Bool {
        get {
            return temperature.count > 0 || weight.count > 0
        }
    }
}

class HCMenstruationModel: HJModel {
    /// 是否为预测
    var isForecast: Bool = false
    
    var bak: String = ""
    var createDate: String = ""
    var creates: String = ""
    var id: String = ""
    var memberId: String = ""
    var menstruationCycle: Int = 0
    var menstruationDate: String = ""
    var menstruationDuration: Int = 0
    var menstruationEndDate: String = ""
    var menstruationWeekEndDate: String = ""
    var modifyDate: String = ""
    var modifys: String = ""
    var ovulationDate: String = ""
    var safePeriodDate: String = ""
}
