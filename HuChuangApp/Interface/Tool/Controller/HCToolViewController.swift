//
//  HCToolViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCToolViewController: BaseViewController {

    private var containerView: HCToolViewContainer!
    private var viewModel: HCToolViewModel!
    
    private var devCtrl: HCUnderDevController!

    override func setupUI() {
        navigationItem.title = "工具"
        
        containerView = HCToolViewContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
        
        containerView.didSelected = { [weak self] in
            if $0.title == "经期设置" {
                self?.navigationController?.pushViewController(HCMenstruationSettingViewController(), animated: true)
            }
        }
        
        devCtrl = HCUnderDevController()
        addChild(devCtrl)
        view.addSubview(devCtrl.view)
    }
    
    override func rxBind() {
        viewModel = HCToolViewModel()
        
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
