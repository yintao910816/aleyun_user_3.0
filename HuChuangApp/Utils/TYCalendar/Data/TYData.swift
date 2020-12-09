//
//  TYData.swift
//  HuChuangApp
//
//  Created by yintao on 2019/10/16.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

class TYCalendarSectionModel {
    
    public var year: Int = 0
    public var month: Int = 0
    
    public var menstruationStartDateStr: String?
    public var menstruationEndDateStr: String?

    /// 当月前面有几天不在当月
    public var daysNotInMonthBefore: Int = 0
    /// 当月后面有几天不在当月
    public var daysNotInMonthAfter: Int = 0

    public var items: [TYCalendarItem] = []
    
    /// 创建所有需要展示的月数据
    public class func creatCalendarData(date: Date) ->[TYCalendarSectionModel] {
        var indexDate: Date = date
        var tempMonthData: [TYCalendarSectionModel] = []
        // 当前日期后面6个月
        for _ in 0..<7 {
            tempMonthData.append(creatMonth(date: indexDate))
            
            if let nextDate = TYDateFormatter.getDate(fromData: indexDate, identifier: .next) {
                indexDate = nextDate
            }else {
                return tempMonthData
            }
        }
        return tempMonthData
    }
    
    /// 创建一个月展示数据
    public class func creatSignalCalendarData(date: Date, identifier: DateIdentifier.month? = nil) ->TYCalendarSectionModel? {
        if let id = identifier {
            let indexDate = TYDateFormatter.getDate(fromData: date, identifier: id)
            if let newDate = indexDate {
                return creatMonth(date: newDate)
            }
            return nil
        }else {
            return creatMonth(date: date)
        }
    }

    /// 创建本月，前一个月，后一个月展示数据
    public class func createMenturationDatas() ->[TYCalendarSectionModel] {
        var tempMonthData: [TYCalendarSectionModel] = []

        let indexDate: Date = Date()
        let beforeDate: Date? = TYDateFormatter.getDate(fromData: indexDate, identifier: .previous)
        let afterDate: Date? = TYDateFormatter.getDate(fromData: indexDate, identifier: .next)

        if let bd = beforeDate {
            tempMonthData.append(creatMonth(date: bd))
        }

        tempMonthData.append(creatMonth(date: indexDate))

        if let ad = afterDate {
            tempMonthData.append(creatMonth(date: ad))
        }

        return tempMonthData
    }
    
    /// 判断这个section是否属于某个日期
    public func isContain(date: String) ->Bool {
        let mText: String = month < 10 ? "0\(month)" : "\(month)"
        let dateText: String = "\(year)-\(mText)"
        return date.contains(dateText)
    }
    
    public func createDateText(day: Int) ->String {
        let m = month < 10 ? "0\(month)" : "\(month)"
        let d = day < 10 ? "0\(day)" : "\(day)"
        return "\(year)-\(m)-\(d)"
    }
    
    public var dateText: String {
        get {
            let m = month < 10 ? "0\(month)" : "\(month)"
            return "\(year)-\(m)"
        }
    }
}

extension TYCalendarSectionModel {
    
    /// 创建月数据
    private class func creatMonth(date: Date) ->TYCalendarSectionModel {
        let month = TYCalendarSectionModel()
        month.year = TYDateFormatter.getYear(date: date)
        month.month = TYDateFormatter.getMonth(date: date)

        var items = [TYCalendarItem]()
        // 该月第一天周几
        let firstDay = TYDateFormatter.getFirstDayInDateMonth(date: date)
        // 获取下一个月
        let nextMonth = TYDateFormatter.getMonth(fromDate: date, identifier: .next)
        let nextMonthDays = TYDateFormatter.calculateDays(fromMonth: date, identifier: .next)
        // 获取上一个月
        let lastMonth = TYDateFormatter.getMonth(fromDate: date, identifier: .previous)
        let lastMonthDays = TYDateFormatter.calculateDays(fromMonth: date, identifier: .previous)

        // 该月所有天数
        let days = TYDateFormatter.calculateDays(forMonth: date)
        let startIdx = firstDay - 1
        
        month.daysNotInMonthBefore = startIdx
        
        if let aLastMonthDays = lastMonthDays, let aLastMonth = lastMonth {
            for day in 0..<startIdx {
                let dayItem = TYCalendarItem()
                dayItem.day = aLastMonthDays - (startIdx - 1 - day)
                dayItem.month = aLastMonth
                dayItem.year = TYDateFormatter.getYear(date: date)
                dayItem.isInMonth = false
                items.append(dayItem)
            }
        }
        
        for day in 0..<days {
            let dayItem = TYCalendarItem()
            dayItem.day = day + 1
            dayItem.month = month.month
            dayItem.year = month.year
            items.append(dayItem)
        }
        
        let needAddCount: Int = 7 - (items.count % 7)
        
        month.daysNotInMonthAfter = needAddCount
        
        /// 最后一行补满七天
        if needAddCount > 0 {
            if let _ = nextMonthDays, let aNextMonth = nextMonth {
                for day in 0..<(7*6 - items.count) {
                    if day >= needAddCount {
                        break
                    }
                    let dayItem = TYCalendarItem()
                    dayItem.isInMonth = false
                    dayItem.day = day + 1
                    dayItem.month = aNextMonth
                    dayItem.year = TYDateFormatter.getYear(date: date)
                    items.append(dayItem)
                }
            }
        }
        
        month.items = items
        return month
    }
}

class TYCalendarItem {
    public var year: Int = 0
    public var month: Int = 0
    public var day: Int = 0
    
    public var isInMonth: Bool = true
    public var isSelected: Bool = false
    
//    /// 非预测月经时间（准确的月经时间）
//    public var menstruationDateStrs: [String] = []
    
    public var mensturationMode: HCMenstruationMode = .none
    public var menstruationModel: HCBaseInfoItemModel?
    
    public var topRightIcon: UIImage?
    public var bottomLeftIcon: UIImage?
    public var bottomRightIcon: UIImage?

    public var dateText: String {
        get {
            let m = month < 10 ? "0\(month)" : "\(month)"
            let d = day < 10 ? "0\(day)" : "\(day)"
            return "\(year)-\(m)-\(d)"
        }
    }
    
    public var remindText: String {
        get {
            switch mensturationMode {
            case .yjq:
                return "推算当日处于月经期"
            case .aqq, .none:
                return "推算当日处于安全期"
            case .plr:
                return "推算当日处于排卵日"
            case .plq:
                return "推算当日处于排卵期"
            }
        }
    }

    public class func isClickedMenstruaItem(title: String) ->Bool {
        return title == "大姨妈来了" || title == "大姨妈走了"
    }
    
    /// 获取当前选中日期的月经信息
    public func getYJInfo(menstruationStart: String?, menstruationEnd: String?) ->(Bool, String) {
        var isOn = false
        var remindText: String = "大姨妈来了"
        
        if let start = menstruationStart {
            if let startDate = start.stringFormatDate(mode: .yymmdd),
               let itemDate = dateText.stringFormatDate(mode: .yymmdd){
                switch itemDate.dateCompare(date: startDate) {
                case .orderedAscending:
                    // 标记的月经开始日之前
                    isOn = false
                    remindText = "大姨妈来了"
                case .orderedDescending:
                    // 标记的月经开始日之后
                    if let end = menstruationEnd {
                        if let endDate = end.stringFormatDate(mode: .yymmdd){
                            switch itemDate.dateCompare(date: endDate) {
                            case .orderedAscending:
                                // 月经结束日之前
                                isOn = false
                                remindText = "大姨妈走了"
                            case .orderedDescending:
                                // 月经结束日之后
                                isOn = false
                                remindText = "大姨妈走了"
                            case .orderedSame:
                                // 月经结束日
                                isOn = true
                                remindText = "大姨妈走了"
                            }
                        }
                    }else {
                        isOn = false
                        remindText = "大姨妈走了"
                    }
                case .orderedSame:
                    // 标记的月经开始日
                    isOn = true
                    remindText = "大姨妈来了"
                }
            }
        }
                
        return (isOn, remindText)
    }
    
    /// 月经期背景颜色
    public var bgColor: UIColor {
        get {
            switch mensturationMode {
            case .yjq:
                if isAfterToday {
                    // 该天属于预测经期
                    return RGB(254, 199, 203)
                }else {                    
                    // 该天属于非预测经期
                    return RGB(255, 79, 120)
                }
            default:
                return .white
            }
        }
    }
    
    /// 如果是月经期，底部左边的月经开始和结束图标的显示就要判断（只有是标记了才会显示）
    public var isBottomLeftIconHidden: Bool {
        get {
            if mensturationMode == .yjq {
                return isAfterToday
            }
            return false
        }
    }
        
    // 判断该日期是否在今天之后
    public var isAfterToday: Bool {
        get {
            var isAfter = false
            
            let todayStr = Date().formatDate(mode: .yymmdd)
            if let itemDate = dateText.stringFormatDate(mode: .yymmdd),
               let todayDate = todayStr.stringFormatDate(mode: .yymmdd) {
                switch itemDate.dateCompare(date: todayDate) {
                case .orderedAscending:
                    // 在今天之前
                    isAfter = false
                case .orderedDescending:
                    // 在今天之后
                    isAfter = true
                case .orderedSame:
                    // 今天
                    isAfter = false
                }
            }
            
            return isAfter
        }
    }
}
