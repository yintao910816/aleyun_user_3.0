//
//  HCAppConfig.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import UIKit

let PPScreenW = UIScreen.main.bounds.size.width
let PPScreenH = UIScreen.main.bounds.size.height

public func RGB(_ r : CGFloat, _ g : CGFloat, _ b : CGFloat, _ a : CGFloat = 1) ->UIColor{
    return UIColor(red : r / 255.0 ,green : g / 255.0 ,blue : b / 255.0 ,alpha : a)
}

let HC_MAIN_COLOR = RGB(253, 119, 146)

let weixinAppid = "wx870ac6243698c3f6"
let weixinSecret = "a570e4ced87a8c3564217b3e8159d4f6"

// 爱乐孕 appid
let ileyun_appid: String = "1241588748"
