//
//  HCReservationViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCReservationViewController: BaseViewController {

    private var viewModel: HCReservationViewModel!
    
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
        viewModel = HCReservationViewModel()
        
        accurateReservationCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)

        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
//                switch strongSelf.viewModel.currentMode {
//                case .picConsult:
//                    strongSelf.picConsultCtrl.reloadData(data: $0)
//                case .videoConsult:
//                    strongSelf.videoConsultCtrl.reloadData(data: $0)
//                case .cloudClinic:
//                    strongSelf.cloudClinicConsultCtrl.reloadData(data: $0)
//                }
            })
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        slideCtrl.view.frame = .init(x: 0, y: 0, width: view.width, height: view.height)
    }
}
