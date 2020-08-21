//
//  HCCouponViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/21.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCCouponViewController: BaseViewController {

    private var viewModel: HCCouponViewModel!
    private var containerView: HCCouponContainer!

    override func setupUI() {
        navigationItem.title = "优惠卷"
        
        containerView = HCCouponContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
    }
    
    override func rxBind() {
        viewModel = HCCouponViewModel()
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] in self?.containerView.couponDatas = $0 })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
