//
//  HCMessageViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMessageViewController: BaseViewController {

    private var viewModel: HCMessageViewModel!
    private var container: HCMessageContainer!
    
    override func setupUI() {
        navigationItem.title = "通知消息"
        
        container = HCMessageContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(container)
    }
    
    override func rxBind() {
        viewModel = HCMessageViewModel()
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] in
                self?.container.reloadData(data: $0)
            })
            .disposed(by: disposeBag)
        
        container.collectionView.prepare(viewModel, showFooter: false)
        container.collectionView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}
