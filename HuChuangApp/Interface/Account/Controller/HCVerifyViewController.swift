//
//  HCVerifyViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/7.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCVerifyViewController: BaseViewController {

    private var containerView: HCVerifyViewContainer!
    private var viewModel: HCVerifyViewModel!
    private var mobile: String = ""
    private var openId: String?

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerView.becomeFirstResponder()
    }
    
    override func setupUI() {
        let topArea = LayoutSize.fitTopArea + 87
        containerView = HCVerifyViewContainer.init(frame: .init(x: 0, y: topArea,
                                                                width: view.width,
                                                                height: view.height - topArea - LayoutSize.bottomVirtualArea))
        view.addSubview(containerView)
        
        containerView.finishInput = { [weak self] in
            self?.viewModel.codeSignal.onNext($0)
        }
    }
    
    override func rxBind() {
        
        viewModel = HCVerifyViewModel(mobile: mobile, openId: openId)
        
        viewModel.beginTimer.onNext(Void())
        
        viewModel.remindSectionSignal.asDriver()
            .drive(containerView.timeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] in
                HCHelper.share.isPresentLogin = false
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.popLoginSubject
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    override func prepare(parameters: [String : Any]?) {
        mobile = parameters!["mobile"] as! String
        openId = parameters?["openId"] as? String
    }
}
