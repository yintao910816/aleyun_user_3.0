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
                NoticesCenter.alert(message: "确定退出当前账号？", cancleTitle: "取消", okTitle: "确定", presentCtrl: self, callBackOK: {
                    HCHelper.presentLogin()
                })
            }else if $0.title == "账号设置" {
                self?.navigationController?.pushViewController(HCAccountSettingViewController(), animated: true)
            }else if $0.title == "消息通知" {
                self?.navigationController?.pushViewController(HCMessageViewController(), animated: true)
            }else if $0.title == "法律声明" {
                HCHelper.pushH5(href: "https://ileyun.ivfcn.com/cms/0-1072.html", title: "法律声明")
            }else if $0.title == "隐私" {
                HCHelper.pushH5(href: "https://ileyun.ivfcn.com/cms/0-1073.html", title: "隐私")
            }else if $0.title == "鼓励我们，给我们评分" {
                HCHelper.gotoAppstorePraise()
            }else if $0.title == "清除缓存" {
                self?.viewModel.clearCacheSignal.onNext(Void())
            }
        }
    }
    
    override func rxBind() {
        viewModel = HCSettingViewModel()
        
        viewModel.listItemSignal.asObservable()
            .subscribe(onNext: { [weak self] in self?.containerView.listData = $0 })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
