//
//  HCReservationViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCReservationViewController: BaseViewController, VMNavigation {
    
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
        accurateReservationCtrl.pushH5CallBack = { [unowned self] in dealPush(mode: $0.0, model: $0.1) }
    }
    
    private func dealPush(mode: HCMyConsultDetailMode?, model: HCAccurateConsultItemModel) {
        if let _mode = mode {
            switch _mode {
            case .chat:
                let url = APIAssistance.consultationChat(with: model.consultId)
                navigationController?.pushViewController(BaseWebViewController.createWeb(url: url,
                                                                                         title: model.userName),
                                                         animated: true)
            case .order:
                let url = APIAssistance.orderDetail(with: model.consultId)
                navigationController?.pushViewController(BaseWebViewController.createWeb(url: url,
                                                                                         title: "订单详情"),
                                                         animated: true)
            case .pay:
                let url = APIAssistance.orderDetail(with: model.orderSn)
                let ctrl = HCConsultChatController()
                ctrl.prepare(parameters: ["url": url, "title": "支付"])
                navigationController?.pushViewController(ctrl, animated: true)
            }
        }else {
            switch model.statusMode {
            case .unpay:
                let url = APIAssistance.orderDetail(with: model.consultId)
                let webCtrl = HCH5ViewController()
                webCtrl.prepare(parameters: ["url": url, "title": "订单详情"])
                navigationController?.pushViewController(webCtrl, animated: true)
            case .cancelled, .finished:
                let params = HCShareWebViewController.configParameters(mode: .doctor,
                                                                       model: HCShareDataModel.transformAccurateConsultModel(model: model),
                                                                       needUnitId: false,
                                                                       isAddRightItems: false)
                HCReservationViewController.push(HCShareWebViewController.self, params)
            case .waiteReceive, .receiving:
                let url = APIAssistance.consultationChat(with: model.consultId)
                HCReservationViewController.push(HCConsultChatController.self, ["url": url, "title": model.userName])
            default:
                break
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        slideCtrl.view.frame = .init(x: 0, y: 0, width: view.width, height: view.height)
    }
}
