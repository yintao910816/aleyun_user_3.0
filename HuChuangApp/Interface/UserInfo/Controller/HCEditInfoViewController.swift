//
//  HCEditInfoViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCEditInfoViewController: BaseViewController {

    private var containerView: HCEditInfoContainer!

    private var viewModel: HCEditInfoViewModel!
    
    override func setupUI() {
        title = "修改昵称"
        
        containerView = HCEditInfoContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
    }
    
    override func rxBind() {
        let commitSignal = addBarItem(title: "完成", titleColor: HC_MAIN_COLOR, right: true)

        viewModel = HCEditInfoViewModel(inputSignal: containerView.textField.rx.text.orEmpty.asDriver(),
                                        commitSignal: commitSignal)
        
        viewModel.enableSignal
            .bind(to: navigationItem.rightBarButtonItem!.rx.isEnabled)
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
