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
        accurateReservationCtrl.pushH5CallBack = { [weak self] in
            switch $0.0 {
            case .chat:
                let url = APIAssistance.consultationChat(with: $0.1.consultId)
                self?.navigationController?.pushViewController(BaseWebViewController.createWeb(url: url,
                                                                                               title: $0.1.userName),
                                                               animated: true)
            case .order:
                let url = APIAssistance.orderDetail(with: $0.1.consultId)
                self?.navigationController?.pushViewController(BaseWebViewController.createWeb(url: url,
                                                                                               title: "订单详情"),
                                                               animated: true)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        slideCtrl.view.frame = .init(x: 0, y: 0, width: view.width, height: view.height)
    }
}
