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
//        let titles: [String] = ["账号设置", "消息通知", "清除缓存", "法律声明", "隐私", "鼓励我们，给我们评分"]

        containerView.didSelected = { [weak self] in
            if $0.title == "退出登陆" {
                HCHelper.presentLogin()
            }else if $0.title == "账号设置" {
                self?.navigationController?.pushViewController(HCAccountSettingViewController(), animated: true)
            }else if $0.title == "消息通知" {
                self?.navigationController?.pushViewController(HCMessageViewController(), animated: true)
            }else if $0.title == "法律声明" {
                self?.navigationController?.pushViewController(HCUnderDevController.ctrlCreat(navTitle: "法律声明"),
                                                               animated: true)
            }else if $0.title == "隐私" {
                self?.navigationController?.pushViewController(HCUnderDevController.ctrlCreat(navTitle: "隐私"),
                                                               animated: true)
            }else if $0.title == "鼓励我们，给我们评分" {
                HCHelper.gotoAppstorePraise()
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
