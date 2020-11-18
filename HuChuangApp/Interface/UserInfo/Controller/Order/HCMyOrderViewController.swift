//
//  HCMyOrderViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMyOrderViewController: BaseViewController {

    private var containerView: HCMyOrderContainer!
    private var viewModel: HCMyOrderViewModel!

    override func setupUI() {
        navigationItem.title = "订单记录"

        containerView = HCMyOrderContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
    }
    
    override func rxBind() {
        viewModel = HCMyOrderViewModel()
        containerView.tableView.prepare(viewModel)
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] in self?.containerView.datasource = $0 })
            .disposed(by: disposeBag)
        
        viewModel.isEmptyContentObser.value = true
        
//        containerView.tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
