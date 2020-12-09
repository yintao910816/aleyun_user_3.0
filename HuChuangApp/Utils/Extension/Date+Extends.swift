//
//  Date+Extends.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/7.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

public enum HCDateMode: String {
    /// yyyy-MM
    case yymm = "yyyy-MM"
    /// yyyy-MM-dd
    case yymmdd = "yyyy-MM-dd"
    /// yyyy-MM-dd HH:mm
    case yymmddhhmm = "yyyy-MM-dd HH:mm"
    /// yyyy-MM-dd HH:mm:ss
    case yymmddhhmmss = "yyyy-MM-dd HH:mm:ss"
}

extension Date {
    
    /// 当前时间格式化字符串
    public static func formatCurrentDate(mode: HCDateMode) ->String {
        return Date().formatDate(mode: mode)
    }
    
    public func formatDate(mode: HCDateMode) ->String {
        let formatter = DateFormatter()
        formatter.dateFormat = mode.rawValue
        let dateStr = formatter.string(from: self)
//        PrintLog("时间已格式化为字符串：\(dateStr)")
        return dateStr
    }
    
    /// 获取当前时间戳
    public static func timepStr() ->String {
        let dat:Date = Date.init(timeIntervalSinceNow: 0)
        let a:TimeInterval = dat.timeIntervalSince1970
        let timep = UInt64(a)
        return "\(timep)"
    }
    
    /// 本月开始日期
    public func startOfCurrentMonth() -> Date {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.year, .month]), from: self)
        let startOfMonth = calendar.date(from: components)!
        return startOfMonth
    }
    
    /// 比较两个时间大小
    public func dateCompare(date: Date) ->ComparisonResult {
        /**
         * self < date orderedAscending升序排列
         * self = date orderedSame 相等
         * self > date orderedDescending 降序排列
         **/
        return compare(date)
    }
}
