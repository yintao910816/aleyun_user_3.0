//
//  HCMineViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMineViewController: BaseViewController, VMNavigation {

    private var containerView: HCMineViewContainer!
    private var viewModel: HCMineViewModel!
    
    override func viewWillAppear(_ animated: Bool) {        
        navigationController?.navigationBar.barTintColor = RGB(255, 244, 251)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : RGB(51, 51, 51),
                                                                   NSAttributedString.Key.font : UIFont.font(fontSize: 18, fontName: .PingFRegular)]
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func setupUI() {
        containerView = HCMineViewContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
        
        containerView.excuteAction = { [weak self] in
            switch $0 {
            case .verify:
                self?.navigationController?.pushViewController(HCRealNameAuthorViewController(), animated: true)
            case .avatar:
                self?.navigationController?.pushViewController(HCAccountSettingViewController(), animated: true)
            case .coupon:
                self?.navigationController?.pushViewController(HCCouponViewController(), animated: true)
            case .serverBags:
                self?.navigationController?.pushViewController(HCUnderDevController.ctrlCreat(navTitle: "服务包"),
                                                               animated: true)
            case .attentionStore:
                self?.navigationController?.pushViewController(HCCollectionViewController(), animated: true)
            case .allInServer:
                HCMineViewController.push(HCMyInServerController.self, ["models": self?.viewModel.personalCenterInfoSignal.value.progressServices ?? [HCPersonalProgressServiceModel]()])
            }
        }
        
        containerView.excuteMyServerAction = { [weak self] in
            switch $0 {
            case .consult:
                self?.navigationController?.pushViewController(HCMyConsultViewController(), animated: true)
            case .reservation:
                self?.navigationController?.pushViewController(HCReservationViewController(), animated: true)
            case .order:
                self?.navigationController?.pushViewController(HCMyOrderViewController(), animated: true)
            case .record:
                self?.navigationController?.pushViewController(HCMyRecordViewController(), animated: true)
            }
        }
        
        containerView.excuteHealthyAction = {
            HCMineViewController.push(BaseWebViewController.self, ["url":APIAssistance.HealthRecords(),
                                                                   "title":"健康档案"])
        }
        
        containerView.excuteInServerAction = {
            let url = APIAssistance.consultationChat(with: $0.consultId)
            HCMineViewController.push(HCConsultChatController.self, ["url": url, "title": $0.userName])
        }
        
        containerView.pushDoctorListAction = { [unowned self] in
            navigationController?.pushViewController(HCExpertConsultationController(), animated: true)            
        }
        
        addBarItem(normal: "setting", right: true, edgeLeft: 20)
            .drive(onNext: { [weak self] in
                self?.navigationController?.pushViewController(HCSettingViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func rxBind() {
        viewModel = HCMineViewModel()
        
        viewModel.personalCenterInfoSignal
            .asDriver()
            .drive(onNext: { [weak self] in self?.containerView.model = $0 })
            .disposed(by: disposeBag)
        
        viewModel.userInfoSignal
            .asDriver()
            .drive(onNext: { [weak self] in self?.containerView.userModel = $0 })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
