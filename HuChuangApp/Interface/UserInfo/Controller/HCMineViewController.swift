//
//  HCMineViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMineViewController: BaseViewController {

    private var containerView: HCMineViewContainer!
    private var viewModel: HCMineViewModel!
    
    override func viewWillAppear(_ animated: Bool) {        
        navigationController?.navigationBar.barTintColor = RGB(255, 244, 251)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : RGB(51, 51, 51),
                                                                   NSAttributedString.Key.font : UIFont.font(fontSize: 18, fontName: .PingFRegular)]
    }
    
    override func setupUI() {
        containerView = HCMineViewContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
        
        containerView.excuteAction = { [weak self] in
            switch $0 {
            case .verify:
                break
            case .avatar:
                self?.navigationController?.pushViewController(HCAccountSettingViewController(), animated: true)
            case .coupon:
                self?.navigationController?.pushViewController(HCCouponViewController(), animated: true)
            case .attentionStore:
                self?.navigationController?.pushViewController(HCCollectionViewController(), animated: true)
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
        
        addBarItem(normal: "setting", right: true)
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

        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
