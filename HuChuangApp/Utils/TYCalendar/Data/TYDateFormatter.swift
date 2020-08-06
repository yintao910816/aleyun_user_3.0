//
//  TYDateFormatter.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/14.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

enum DateIdentifier {
    enum month: Int {
        case next = 1
        case previous = -1
    }
}

class TYDateFormatter {
    // 参考 https://www.jianshu.com/p/e242a09a27e6
    
    /// 获取指定月份的天数
    class func calculateDays(forMonth date: Date) ->Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM"
        let calendar = Calendar.init(identifier: .gregorian)
        guard let range = calendar.range(of: .day, in: .month, for: date) else {
            return 30
        }
        PrintLog("获取指定月份的天数 - \(range)")
        return range.endIndex - 1
    }
    
    /// 获取前一月，下一个月的月份天数
    class func calculateDays(fromMonth date: Date, identifier: DateIdentifier.month) ->Int? {
        let calendar = Calendar.init(identifier: .gregorian)
        var comps = DateComponents()
        comps.setValue(identifier.rawValue, for: .month)

        guard let date = calendar.date(byAdding: comps, to: date) else {
            return nil
        }
                
        return calculateDays(forMonth: date)
    }
    
    /// 获取指定日期所在月份的第一天是星期几
    class func getFirstDayInDateMonth(date: Date) -> Int {
        let calendar = Calendar(identifier: .gregorian)
        var specifiedDateCom = calendar.dateComponents([.year,.month], from: date)
        specifiedDateCom.setValue(1, for: .day)
        let startOfMonth = calendar.date(from: specifiedDateCom)
        let weekDayCom = calendar.component(.weekday, from: startOfMonth!)
        return weekDayCom
    }
    
    /// 获取指定年/月/日 的Int
    class func getDataComponent(date: Date, component: Calendar.Component) ->DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents([component], from: date)
    }

    /// 获取指定年的Int
    class func getYear(date: Date) ->Int {
        return getDataComponent(date: date, component: .year).year ?? 0
    }

    /// 获取指定月的Int
    class func getMonth(date: Date) ->Int {
        return getDataComponent(date: date, component: .month).month ?? 0
    }
    
    /// 获取指定日的Int
    class func getDay(date: Date) ->Int {
        return getDataComponent(date: date, component: .day).day ?? 0
    }
    
    /// 获取前一月，下一个月
    class func getMonth(fromDate date: Date, identifier: DateIdentifier.month) ->Int? {
        let calendar = Calendar.init(identifier: .gregorian)
        var comps = DateComponents()
        comps.setValue(identifier.rawValue, for: .month)

        guard let date = calendar.date(byAdding: comps, to: date) else {
            return nil
        }
        
        return getMonth(date: date)
    }
    
    /// 以某个时间为基准，获取下一个月的Date
    class func getDate(fromData date: Date, identifier: DateIdentifier.month) ->Date? {
        let calendar = Calendar.init(identifier: .gregorian)
        var comps = DateComponents()
        comps.setValue(identifier.rawValue, for: .month)

        return calendar.date(byAdding: comps, to: date)
    }
}
