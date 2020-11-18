//
//  HCReservationViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCReservationViewController: BaseViewController {
    
    private var slideCtrl: TYSlideMenuController!
    private var registerReservationCtrl: HCRegisterReservationController!
    private var accurateReservationCtrl: HCAccurateReservationController!

    override func setupUI() {
        navigationItem.title = "我的预约"
        
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        registerReservationCtrl = HCRegisterReservationController()
        accurateReservationCtrl = HCAccurateReservationController()
        
        slideCtrl.menuItems = TYSlideItemModel.createMyReservationData()
        slideCtrl.menuCtrls = [registerReservationCtrl, accurateReservationCtrl]
        
        slideCtrl.pageScroll = { [weak self] page in
//            self?.viewModel.changeMenuSignal.onNext(page)
        }
    }
    
    override func rxBind() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        slideCtrl.view.frame = .init(x: 0, y: 0, width: view.width, height: view.height)
    }
}
