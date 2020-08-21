//
//  HCHomeViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCHomeViewController: BaseViewController {

    private var containerView: HCHomeViewContainer!
    private var viewModel: HCHomeViewModel!
    
    override func setupUI() {
        containerView = HCHomeViewContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
        
        containerView.menuChanged = { [weak self] in self?.viewModel.articleTypeChangeSignal.onNext($0) }
        containerView.articleClicked = { [weak self] in
            PrintLog("点击：\($0.title)")
//            let webVC = BaseWebViewController()
//            webVC.url = $0.picPath
//            self?.navigationController?.pushViewController(webVC, animated: true)
        }
        
        containerView.funcItemClicked = { [weak self] in
            let webVC = BaseWebViewController()
            webVC.url = $0.functionUrl
            webVC.title = $0.name
            self?.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    override func rxBind() {
        viewModel = HCHomeViewModel()
        
        viewModel.functionsMenuSignal.asDriver()
            .drive(onNext: { [weak self] in self?.containerView.reloadData(menuItems: $0.0, cmsChanelListModel: $0.1, page: $0.2) })
            .disposed(by: disposeBag)
        
        viewModel.articleDataSignal
            .subscribe(onNext: { [weak self] in self?.containerView.reloadArticleDatas(datas: $0.0, page: $0.1) })
            .disposed(by: disposeBag)
                
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
