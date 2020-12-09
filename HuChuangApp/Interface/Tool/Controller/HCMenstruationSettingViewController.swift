//
//  HCMenstruationSettingViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/14.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMenstruationSettingViewController: BaseViewController {

    private var viewModel: HCMenstruationSettingViewModel!
    private var containerView: HCMenstruationSettingContainer!

    override func setupUI() {
        title = "经期设置"
        
        containerView = HCMenstruationSettingContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
    }
    
    override func rxBind() {
        let saveSignal = addBarItem(title: "保存", titleColor: HC_MAIN_COLOR)
        
        viewModel = HCMenstruationSettingViewModel(tap: saveSignal)
        
        viewModel.listDatasource.asDriver()
            .drive(onNext: { [weak self] in self?.containerView.listData = $0 })
            .disposed(by: disposeBag)

        viewModel.enableCommitSignal.asDriver()
            .drive(navigationItem.rightBarButtonItem!.rx.rx_enable)
            .disposed(by: disposeBag)

        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
