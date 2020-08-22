//
//  HCMyConsultViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/22.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMyConsultViewController: BaseViewController {

    private var viewModel: HCMyConsultViewModel!
    
    private var slideCtrl: TYSlideMenuController!

    override func setupUI() {
        navigationItem.title = "我的问诊"
        
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        slideCtrl.menuItems = TYSlideItemModel.createMyConsultData()
        slideCtrl.menuCtrls = [HCPicConsultViewController(),
                               HCVideoConsultViewController(),
                               HCCloudClinicConsultViewController()]
        
        slideCtrl.pageScroll = { [weak self] page in
            //            self?.viewModel.requestTodayListSubject.onNext(page)
        }
    }
    
    override func rxBind() {
        viewModel = HCMyConsultViewModel()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        slideCtrl.view.frame = .init(x: 0, y: 0, width: view.width, height: view.height)
    }
}
