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
        
        if let aLastMonthDays = lastMonthDays, let aLastMonth = lastMonth {
            for day in 0..<startIdx {
                let dayItem = TYCalendarItem()
                dayItem.day = aLastMonthDays - (startIdx - 1 - day)
                dayItem.month = aLastMonth
                dayItem.year = TYDateFormatter.getYear(date: date)
                dayItem.textColor = .lightGray
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
        
        if let _ = nextMonthDays, let aNextMonth = nextMonth {
            for day in 0..<(7*6 - items.count) {
                let dayItem = TYCalendarItem()
                dayItem.textColor = .lightGray
                dayItem.day = day + 1
                dayItem.month = aNextMonth
                dayItem.year = TYDateFormatter.getYear(date: date)
                items.append(dayItem)
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
    
    public var textColor: UIColor = .black
}
