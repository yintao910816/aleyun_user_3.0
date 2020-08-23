//
//  HCMyOrderViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCMyOrderViewModel: RefreshVM<HCMyOrderItemModel> {
    
    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
    }
}
