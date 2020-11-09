//
//  Date+Extends.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/7.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

extension Date {
    
    /// 当前时间格式化字符串
    public static func formatCurrentDate() ->String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateStr = formatter.string(from: date)
        return dateStr
    }
}
