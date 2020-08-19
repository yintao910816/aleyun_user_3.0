//
//  HCSettingViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/19.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCSettingViewController: BaseViewController {

    private var containerView: HCSettingContainer!
    private var viewModel: HCSettingViewModel!

    override func setupUI() {
        navigationItem.title = "设置"

        containerView = HCSettingContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
        
        containerView.didSelected = { [weak self] in
            if $0.title == "退出登陆" {
                HCHelper.presentLogin()
            }
        }
    }
    
    override func rxBind() {
        viewModel = HCSettingViewModel()
        
        viewModel.listItemSubject
            .subscribe(onNext: { [weak self] in self?.containerView.listData = $0 })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
