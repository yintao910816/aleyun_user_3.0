//
//  TYDateCalculate.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/14.
//  Copyright © 2019 sw. All rights reserved.
//  时间推算

import Foundation

class TYDateCalculate {
    
    /**
     * 根据一个时间推算出前后多少天的日期
     *  currentDate 当前时间
     *  days 前后多少天
     *  isAfter 是否往后推
     */
    class func getDate(currentDate: Date, days: Int, isAfter: Bool) ->Date {
        let oneDay: TimeInterval = TimeInterval((24 * 60 * 60) * days)
        return currentDate.addingTimeInterval(isAfter ? oneDay : -oneDay)
    }
    
    /**
     * 根据根据两个时间点推算出之间的所有时间
     * startDate 开始时间
     * endDate 结束多少天
     */
    class func getDates(startDate: Date, endDate: Date) ->[Date] {
        var star = startDate
        let end = endDate
        
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.timeZone = TimeZone.init(secondsFromGMT: 8) ?? TimeZone.current
        
        var compontDates: [Date] = []
        var result: ComparisonResult = star.compare(end)
        while result != .orderedDescending {
            var comps = calendar.dateComponents([.year, .month, .day], from: star)
            compontDates.append(star)
            
            // 后一天
            comps.day = comps.day! + 1
            star = calendar.date(from: comps)!
         
            // 对比日期大小
            result = star.compare(end)
        }
        
        for idx in 0..<compontDates.count {
            compontDates[idx] = TYDateCalculate.formatDate(date: compontDates[idx])
        }
        
        return compontDates
    }
    
    /// 获取指定年/月/日 的Int
    class func getDataComponent(date: Date, component: Set<Calendar.Component> = [.month, .day]) ->DateComponents {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.dateComponents(component, from: date)
    }

    /**
     * 字符串格式化时间 yyyy-MM-dd
     */
    class func date(for string: String, mode: HCDateMode = .yymmdd) ->Date {
        let format = DateFormatter()
        format.timeZone = TimeZone.init(secondsFromGMT: 8)
        format.dateFormat = mode.rawValue
        let date = format.date(from: string)
        return date ?? Date()
    }
    
    /**
     * 计算两个时间之间的差值
     */
    class func numberOfDays(fromDate: Date, toDate: Date) -> Int {
        let calendar = Calendar.init(identifier: .gregorian)
        let comp = calendar.dateComponents([.day], from: fromDate, to: toDate)
        return comp.day ?? 0
    }
    
    class func numberOfDays(toDate: String) -> Int {
        return numberOfDays(fromDate: TYDateCalculate.formatNowDate(), toDate: date(for: toDate))
    }
    
    class func numberOfDays(toDate: Date) -> Int {
        return numberOfDays(fromDate: TYDateCalculate.formatNowDate(), toDate: toDate)
    }
    
    /**
     * 将当前时间格式化成指定格式
     */
    class func formatNowDate() ->Date {
        let dateFormat = DateFormatter.init()
        dateFormat.timeZone = TimeZone.init(secondsFromGMT: 8)
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormat.string(from: Date())
        
        return dateFormat.date(from: dateString)!
    }
    
    class func formatNowDateString() ->String {
        let dateFormat = DateFormatter.init()
        dateFormat.timeZone = TimeZone.init(secondsFromGMT: 8)
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let dateString = dateFormat.string(from: Date())
        
        return dateString
    }
    
    class func formatDate(date: Date, mode: HCDateMode = .yymmdd) ->Date {
        let dateFormat = DateFormatter.init()
        dateFormat.timeZone = TimeZone.init(secondsFromGMT: 8)
        dateFormat.dateFormat = mode.rawValue
        
        let dateString = dateFormat.string(from: date)
        
        return dateFormat.date(from: dateString)!
    }
}

extension TYDateCalculate {
    
    /// 判断每天是否在当前月中
    public class func dayContains(in month: String, day: String) ->Bool {
        
        let date = month.stringFormatDate(mode: .yymm)!
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: date)
        let startDate = calendar.date(from: components)!

        let calendar1 = NSCalendar.current
        var components1 = DateComponents()
        components1.month = 1
        components1.day = -1
        let endDate = calendar1.date(byAdding: components1, to: startDate)!

        guard let dateDate = day.stringFormatDate(mode: .yymmdd) else {
            return false
        }
        
        if (dateDate.compare(startDate) == .orderedDescending || dateDate.compare(startDate) == .orderedSame) && (dateDate.compare(endDate) == .orderedAscending || dateDate.compare(endDate) == .orderedSame) {
            return true
        }
        
        return false
    }

    /// 判断每天是否在当前月中
    public class func currentMonthContais(dateString: String) ->Bool {
        let startDate = startOfCurrentMonth()
        let endDate = endOfCurrentMonth()
        
        let formatDate = date(for: dateString)
        
        if numberOfDays(fromDate: startDate, toDate: formatDate) < 0 {
            return false
        }
        
        if numberOfDays(fromDate: formatDate, toDate: endDate) < 0 {
            return false
        }

        return true
    }
    
    /// 本月开始日期
    private class func startOfCurrentMonth() -> Date {
        let date = Date()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(Set<Calendar.Component>([.year, .month]), from: date)
        let startOfMonth = calendar.date(from: components)!
        return startOfMonth
    }
    
    
    /// 本月结束日期
    private class func endOfCurrentMonth(returnEndTime:Bool = false) -> Date {
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.month = 1
        if returnEndTime {
            components.second = -1
        } else {
            components.day = -1
        }
        
        let endOfMonth = calendar.date(byAdding: components, to: startOfCurrentMonth())!
        return endOfMonth
    }
    
    /// 判断当前时间是否在一个时间范围内
    public class func dateIsIn(dateStr: String,
                               startDateStr: String,
                               endDateStr: String,
                               mode: HCDateMode = .yymmdd) ->Bool {
        
        guard let date = dateStr.stringFormatDate(mode: mode),
              let startDate = startDateStr.stringFormatDate(mode: mode),
              let endDate = endDateStr.stringFormatDate(mode: mode)else {
            return false
        }
        
        if date.compare(startDate) == .orderedDescending && date.compare(endDate) == .orderedAscending {
            return true
        }
        
        return false
    }
    
    /// 比较两个时间大小
    public class func compare(dateStr: String, other: String, mode: HCDateMode = .yymmdd) ->ComparisonResult {
        guard let date = dateStr.stringFormatDate(mode: mode),
              let otherDate = other.stringFormatDate(mode: mode) else {
            return .orderedSame
        }
        return date.compare(otherDate)
    }
    
    /// 计算两个时间的差值
    public class func numberOfDays(startStr: String, endStr: String, mode: HCDateMode = .yymmdd) ->Int {
        guard let startDate = startStr.stringFormatDate(mode: mode),
              let endDate = endStr.stringFormatDate(mode: mode) else {
            return 0
        }
        let days = numberOfDays(fromDate: startDate, toDate: endDate)
        return abs(days)
    }
    
}

