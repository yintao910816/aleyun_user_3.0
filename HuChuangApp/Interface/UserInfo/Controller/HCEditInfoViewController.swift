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
            .do(onNext: { [unowned self] in
                self.containerView.endEditing(true)
            })

        viewModel = HCEditInfoViewModel(inputSignal: containerView.textField.rx.text.orEmpty.asDriver(),
                                        commitSignal: commitSignal)
                
        viewModel.enableSignal
            .subscribe(onNext: { [unowned self] in
                let button = self.navigationItem.rightBarButtonItem?.customView as? UIButton
                if $0 == true {
                    button?.setTitleColor(HC_MAIN_COLOR, for: .normal)
                }else {
                    button?.setTitleColor(RGB(182, 182, 182), for: .normal)
                }
                button?.isUserInteractionEnabled = $0
            })
            .disposed(by: disposeBag)
                    
        viewModel.contentSignal
            .bind(to: containerView.textField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
