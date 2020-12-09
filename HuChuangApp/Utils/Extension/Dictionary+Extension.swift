//
//  Dictionary+Extension.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/31.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func getJSONString() -> String {
        if (!JSONSerialization.isValidJSONObject(self)) {
            PrintLog("无法解析出JSONString")
            return ""
        }
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            PrintLog("无法解析出 Data")
            return ""
        }
        
        guard let JSONString = String.init(data: data, encoding: .utf8) else {
            PrintLog("无法解析出 String")
            return ""
        }
        
        return JSONString    
    }
}

extension Array where Element:Hashable{
    
    var deduplicates : [Element] {
        var keys:[Element:()] = [:]
        return filter{ keys.updateValue((), forKey:$0) == nil }
    }
    
    public func deduplicates(aFilter:((Element)->(Bool))) ->[Element] {
        return filter{ aFilter($0) }
    }

}

