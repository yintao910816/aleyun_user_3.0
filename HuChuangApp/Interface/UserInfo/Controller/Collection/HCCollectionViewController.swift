//
//  HCCollectionViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCCollectionViewController: BaseViewController {

    private var slideCtrl: TYSlideMenuController!
    private var viewModel: HCCollectionViewModel!

    override func setupUI() {
        navigationItem.title = "关注收藏"
        
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)

        slideCtrl.menuItems = TYSlideItemModel.createAttentionStoreData()
        slideCtrl.menuCtrls = [HCMyDoctorViewController(), HCMyClassViewController(), HCMyInformationViewController()]
        
        slideCtrl.pageScroll = { [weak self] page in
//            self?.viewModel.requestTodayListSubject.onNext(page)
        }
    }
    
    override func rxBind() {
        viewModel = HCCollectionViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        slideCtrl.view.frame = .init(x: 0, y: 0, width: view.width, height: view.height)
    }
}
