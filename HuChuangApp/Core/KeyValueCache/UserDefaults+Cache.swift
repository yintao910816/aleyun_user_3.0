//
//  UserDefault.swift
//  StoryReader
//
//  Created by 020-YinTao on 2016/11/23.
//  Copyright © 2016年 020-YinTao. All rights reserved.
//

import Foundation

let userDefault = UserDefaults.standard
let noUID = "0"

extension UserDefaults{

    var uid: String {
        get{
            guard let hcUID = (object(forKey: kUID) as? String) else {
                return noUID
            }
            return hcUID
        }
        set{
            set(newValue, forKey: kUID)
            synchronize()
        }
    }
    
    var loginPhone: String {
        get {
            guard let phone = object(forKey: kLoginPhone) as? String else {
                return ""
            }
            return phone
        }
        set {
            set(newValue, forKey: kLoginPhone)
            synchronize()
        }
    }
    
    var token: String {
        get{
            guard let rtToken = (object(forKey: kToken) as? String) else {
                return ""
            }
            return rtToken
        }
        set{
            set(newValue, forKey: kToken)
            synchronize()
        }
    }
    
    var unitId: String {
        get{
//            guard let rtUnitId = (object(forKey: kUnitId) as? String) else {
//                return "0"
//            }
//
//            return rtUnitId
            // 爱乐孕改值写死0
            return "0"
        }
        set{
            set(newValue, forKey: kUnitId)
            synchronize()
        }
    }
    
    /// 接口获取的 unitId
    var unitIdNoEmpty: String {
        get{
            guard let rtUnitId = (object(forKey: kunitIdNoEmpty) as? String) else {
                return "0"
            }
            
            return rtUnitId
        }
        set{
            set(newValue, forKey: kunitIdNoEmpty)
            synchronize()
        }
    }
    
    var loginInfoString: String {
        get {
            guard let string = (object(forKey: kLoginInfoString) as? String) else {
                return ""
            }
            
            return string
        }
        set{
            set(newValue, forKey: kLoginInfoString)
            synchronize()
        }
    }

    var lanuchStatue: String {
        get {
            guard let statue = (object(forKey: kLoadLaunchKey) as? String) else {
                return ""
            }
            return statue
        }
        set {
            set(newValue, forKey: kLoadLaunchKey)
            synchronize()
        }
    }
    
}
