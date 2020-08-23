//
//  HCMyRecordViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMyRecordViewController: BaseViewController {

    private var viewModel: HCMyRecordViewModel!
    
    private var slideCtrl: TYSlideMenuController!
    private var picConsultRecordCtrl: HCPicConsultRecordViewController!
    private var videoConsultRecordCtrl: HCVideoConsultRecordViewController!
    private var accurateReservationRecordCtrl: HCAccurateReservationRecordController!

    override func setupUI() {
        navigationItem.title = "我的预约"
        
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        picConsultRecordCtrl = HCPicConsultRecordViewController()
        videoConsultRecordCtrl = HCVideoConsultRecordViewController()
        accurateReservationRecordCtrl = HCAccurateReservationRecordController()

        slideCtrl.menuItems = TYSlideItemModel.createMyRecordData()
        slideCtrl.menuCtrls = [picConsultRecordCtrl, videoConsultRecordCtrl, accurateReservationRecordCtrl]
        
        slideCtrl.pageScroll = { [weak self] page in
//            self?.viewModel.changeMenuSignal.onNext(page)
        }
    }
    
    override func rxBind() {
        viewModel = HCMyRecordViewModel()
        
        picConsultRecordCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)

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
        
        picConsultRecordCtrl.tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        slideCtrl.view.frame = .init(x: 0, y: 0, width: view.width, height: view.height)
    }
}
