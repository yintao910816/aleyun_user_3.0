//
//  HCRealNameAuthorViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/17.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCRealNameAuthorViewController: BaseViewController {

    private var containerView: HCRealNameAuthorContainer!
    private var viewModel: HCRealNameAuthorViewModel!
    
    override func setupUI() {
        title = "实名认证"
        
        containerView = HCRealNameAuthorContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
        
        containerView.didSelected = { [unowned self] in self.presentPicker(indexPath: $0) }
    }
    
    override func rxBind() {
        viewModel = HCRealNameAuthorViewModel.init(commit: containerView.commitButton.rx.tap.asDriver())
        
        viewModel.listItemSource.asObservable()
            .subscribe(onNext: { [weak self] in self?.containerView.reloadData(data: $0) })
            .disposed(by: disposeBag)
        
        viewModel.popSubject
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }

}

extension HCRealNameAuthorViewController {
    
    private func presentPicker(indexPath: IndexPath) {
        if indexPath.row == 2 {
            let datePicker = HCDatePickerViewController()
            addChildViewController(datePicker)
            datePicker.finishSelected = { [weak self] in
                self?.containerView.reloadItem(indexPath: indexPath, content: $0.1)
            }
        }else if indexPath.row == 3 {
            let picker = HCPickerView()
            picker.datasource = [HCPickerSectionData(items: [HCPickerItemModel(title: "身份证")])]
//            addChildViewController(picker)
            
            model(for: picker, controllerHeight: view.height)
            
            picker.finishSelected = { [weak self] in
                self?.containerView.reloadItem(indexPath: indexPath, content: $0.1)
            }
        }
    }
}
 
