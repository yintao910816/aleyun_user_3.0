//
//  HCServerMsgController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/26.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCServerMsgController: BaseViewController{
    
    private var viewModel: HCServerMsgViewModel!
    private var container: HCServerMsgContainer!
    
    override func setupUI() {
        navigationItem.title = "系统消息"
        
        container = HCServerMsgContainer(frame: view.bounds)
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCServerMsgViewModel()
        container.tableView.prepare(viewModel)
        
        viewModel.datasource.asDriver()
            .drive(container.dataSignal)
            .disposed(by: disposeBag)
        
        container.tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}
