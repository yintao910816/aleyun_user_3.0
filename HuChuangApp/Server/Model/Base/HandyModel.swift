//
//  HandyModel.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import HandyJSON

class HJModel:NSObject ,HandyJSON {
    
    var total: Int = 0
    var size : Int = 0
    var current: Int = 1
    var pages: Int = 0
    
    func mapping(mapper: HelpingMapper) {}
    
    required override init() {}
    
}

/// 数据解耦
protocol HCDataSourceAdapt {
    
    var viewHeight: CGFloat { get }
}
