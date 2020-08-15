//
//  HCAccountSettingViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCAccountSettingViewController: BaseViewController {

    private var containerView: HCAccountSettingContainer!

    private var viewModel: HCAccountSettingViewModel!
    
    override func setupUI() {
        title = "账号设置"
        
        containerView = HCAccountSettingContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
        
        containerView.didSelected = { [weak self] in
            if $0.title == "昵称" {
                self?.navigationController?.pushViewController(HCEditInfoViewController(), animated: true)
            }
        }
    }
    
    override func rxBind() {
        viewModel = HCAccountSettingViewModel()
        
        viewModel.listItemSubject
            .subscribe(onNext: { [weak self] in self?.containerView.reloadData(data: $0) })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
