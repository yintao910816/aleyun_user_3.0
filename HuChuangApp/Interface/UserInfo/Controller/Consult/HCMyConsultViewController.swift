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
    private var picConsultCtrl: HCPicConsultViewController!
    private var videoConsultCtrl: HCVideoConsultViewController!
    private var cloudClinicConsultCtrl: HCCloudClinicConsultViewController!

    override func setupUI() {
        navigationItem.title = "我的问诊"
        
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        picConsultCtrl = HCPicConsultViewController()
        picConsultCtrl.pushH5CallBack = { [weak self] in
            let url = APIAssistance.consultationChat(with: $0.consultId)
            self?.navigationController?.pushViewController(BaseWebViewController.createWeb(url: url,
                                                                                           title: $0.userName),
                                                           animated: true)
        }
        
        videoConsultCtrl = HCVideoConsultViewController()
        cloudClinicConsultCtrl = HCCloudClinicConsultViewController()
        
        slideCtrl.menuItems = TYSlideItemModel.createMyConsultData()
        slideCtrl.menuCtrls = [picConsultCtrl, videoConsultCtrl, cloudClinicConsultCtrl]
        
        slideCtrl.pageScroll = { [weak self] page in
            self?.viewModel.changeMenuSignal.onNext(page)
        }
    }
    
    override func rxBind() {
        viewModel = HCMyConsultViewModel()
        
        picConsultCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)
        videoConsultCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)
        cloudClinicConsultCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)

        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                switch strongSelf.viewModel.currentMode {
                case .picConsult:
                    strongSelf.picConsultCtrl.reloadData(data: $0)
                case .videoConsult:
                    strongSelf.videoConsultCtrl.reloadData(data: $0)
                case .cloudClinic:
                    strongSelf.cloudClinicConsultCtrl.reloadData(data: $0)
                }
            })
            .disposed(by: disposeBag)
        
        picConsultCtrl.tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        slideCtrl.view.frame = .init(x: 0, y: 0, width: view.width, height: view.height)
    }
}
