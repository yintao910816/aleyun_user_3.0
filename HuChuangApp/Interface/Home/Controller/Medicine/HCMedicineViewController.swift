//
//  HCMedicineViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/27.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCMedicineViewController: BaseViewController {

    private var viewModel: HCMedicineViewModel!
    private var container: HCMedicineContainer!
    
    override func setupUI() {
        navigationItem.title = "药品百科"
        
        container = HCMedicineContainer.init(frame: view.bounds)
        view.addSubview(container)
        
        container.cellDidSelected = { [weak self] in
            let url = APIAssistance.medicineDetail(with: $0.id)
            self?.navigationController?.pushViewController(BaseWebViewController.createWeb(url: url,
                                                                                           title: "详情"),
                                                           animated: true)
        }
    }
    
    override func rxBind() {
        viewModel = HCMedicineViewModel()
        container.collectionView.prepare(viewModel, showFooter: false)
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] in self?.container.datasource = $0 })
            .disposed(by: disposeBag)
        
        container.collectionView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}
