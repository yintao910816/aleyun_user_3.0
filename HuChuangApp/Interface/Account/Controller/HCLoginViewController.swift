//
//  HCLoginViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxSwift

class HCLoginViewController: BaseViewController {
    
    public var containerView: HCLoginViewContainer!
    
    private var viewModel: HCLoginViewModel!
        
    override func viewWillAppear(_ animated: Bool) {        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        let topArea = LayoutSize.fitTopArea + 87
        containerView = HCLoginViewContainer.init(frame: .init(x: 0, y: topArea,
                                                               width: view.width,
                                                               height: view.height - topArea - LayoutSize.bottomVirtualArea))
        view.addSubview(containerView)

        containerView.agreementTap = { [weak self] in
            let url = "https://ileyun.ivfcn.com/cms/alyyhxy.html"
            self?.navigationController?.pushViewController(BaseWebViewController.createWeb(url: url),
                                                           animated: true)
        }
        
        containerView.platformContainer.isHidden = !HCHelper.share.enableWchatLogin
    }
    
    override func rxBind() {
        HCHelper.share.enableWchatLoginSubjet
            .subscribe(onNext: { [weak self] in
                self?.containerView.platformContainer.isHidden = !$0
            })
            .disposed(by: disposeBag)
        
        containerView.fastLoginButton.rx.tap.asDriver()
            .drive(onNext: { [unowned self] in
                (UIApplication.shared.delegate as? HCAppDelegate)?.setupUniLogin(viewController: self)
            })
            .disposed(by: disposeBag)

        viewModel = HCLoginViewModel.init(input: containerView.phoneTf.rx.text.orEmpty.asDriver(),
                                          tap: (codeTap: containerView.getCodeButton.rx.tap.asDriver(),
                                                agreeTap: containerView.agreeSignal.asDriver(),
                                                weChatTap: containerView.wchatLoginButton.rx.tap.asDriver()))
        viewModel.enableCode
            .do(onNext: { [weak self] flag in
                self?.containerView.getCodeButton.backgroundColor = flag ? HC_MAIN_COLOR : RGB(242, 242, 242)
                self?.containerView.getCodeButton.isSelected = flag
            })
            .drive(containerView.getCodeButton.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] in self?.dismiss(animated: true, completion: nil) })
            .disposed(by: disposeBag)
        
    }
    
}
