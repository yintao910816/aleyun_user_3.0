//
//  HCBindPhoneController.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/18.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCBindPhoneController: HCLoginViewController {

    private var viewModel: HCBindPhoneViewModel!
    private var openId: String = ""
    
    override func setupUI() {
        super.setupUI()
        
        containerView.platformContainer.isHidden = true
    }
    
    override func rxBind() {
        viewModel = HCBindPhoneViewModel.init(input: containerView.phoneTf.rx.text.orEmpty.asDriver(),
                                              openId: openId,
                                              tap: (codeTap: containerView.getCodeButton.rx.tap.asDriver(),
                                                agreeTap: containerView.agreeSignal.asDriver()))
        viewModel.enableCode
            .do(onNext: { [weak self] flag in
                self?.containerView.getCodeButton.backgroundColor = flag ? HC_MAIN_COLOR : RGB(242, 242, 242)
                self?.containerView.getCodeButton.isSelected = flag
            })
            .drive(containerView.getCodeButton.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
    }
    
    override func prepare(parameters: [String : Any]?) {
        openId = parameters!["openId"] as! String
    }
}
