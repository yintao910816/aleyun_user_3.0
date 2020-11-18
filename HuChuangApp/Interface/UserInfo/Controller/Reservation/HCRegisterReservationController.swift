//
//  HCRegisterReservationController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//  预约挂号

import UIKit

class HCRegisterReservationController: HCSlideItemController {

    private var viewModel: HCRegisterReservationViewModel!
    
    override func setupUI() {
        
    }
    
    override func rxBind() {
        viewModel = HCRegisterReservationViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
