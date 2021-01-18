//
//  HCMyConsultViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/22.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

enum HCMyConsultDetailMode {
    case chat
    case order
}

class HCMyConsultViewController: BaseViewController {

    private var status: Int?
    private var viewModel: HCMyConsultViewModel!
    
    private var slideCtrl: TYSlideMenuController!
    private var picConsultCtrl: HCPicConsultViewController!
    private var videoConsultCtrl: HCVideoConsultViewController!
    private var cloudClinicConsultCtrl: HCCloudClinicConsultViewController!

    override func setupUI() {
        navigationItem.title = "咨询"
        
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        picConsultCtrl = HCPicConsultViewController()
        picConsultCtrl.pushH5CallBack = { [weak self] in
            switch $0.0 {
            case .chat:
                let url = APIAssistance.consultationChat(with: $0.1.consultId)
                let ctrl = HCConsultChatController()
                ctrl.prepare(parameters: ["url": url, "title": $0.1.userName])
                self?.navigationController?.pushViewController(ctrl, animated: true)
            case .order:
                let url = APIAssistance.orderDetail(with: $0.1.consultId)
                let ctrl = HCConsultChatController()
                ctrl.prepare(parameters: ["url": url, "title": "订单详情"])
                self?.navigationController?.pushViewController(ctrl, animated: true)
            }
        }
        
        videoConsultCtrl = HCVideoConsultViewController()
        videoConsultCtrl.pushH5CallBack = { [weak self] in
            switch $0.0 {
            case .chat:
                let url = APIAssistance.consultationChat(with: $0.1.consultId)
                let ctrl = HCConsultChatController()
                ctrl.prepare(parameters: ["url": url, "title": $0.1.userName])
                self?.navigationController?.pushViewController(ctrl, animated: true)
            case .order:
                let url = APIAssistance.orderDetail(with: $0.1.consultId)
                let ctrl = HCConsultChatController()
                ctrl.prepare(parameters: ["url": url, "title": "订单详情"])
                self?.navigationController?.pushViewController(ctrl, animated: true)
            }
        }

        cloudClinicConsultCtrl = HCCloudClinicConsultViewController()
        
        slideCtrl.menuItems = TYSlideItemModel.createMyConsultData()
        slideCtrl.menuCtrls = [picConsultCtrl, videoConsultCtrl, cloudClinicConsultCtrl]
        
        slideCtrl.pageScroll = { [weak self] page in
            self?.viewModel.changeMenuSignal.onNext(page)
        }
    }
    
    override func rxBind() {
        viewModel = HCMyConsultViewModel(status: status)
        
        picConsultCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: true)
        videoConsultCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: true)
        cloudClinicConsultCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: true)

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
    
    override func prepare(parameters: [String : Any]?) {
        status = parameters?["status"] as? Int
    }
}
