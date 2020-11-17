//
//  HCTestTubeViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/26.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCTestTubeViewController: BaseViewController {

    private var viewModel: HCTestTubeViewModel!
    private var container: HCTestTubeContainer!
    
    override func setupUI() {
        navigationItem.title = "试管百科"
        
        container = HCTestTubeContainer.init(frame: view.bounds)
        view.addSubview(container)
        
        container.cellDidSelected = { [weak self] in self?.viewModel.articleDetailSignal.onNext($0) }
    }
    
    override func rxBind() {
        viewModel = HCTestTubeViewModel()
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] in self?.container.datasource = $0 })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}
