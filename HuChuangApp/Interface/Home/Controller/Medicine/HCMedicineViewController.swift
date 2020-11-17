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
        
        container.cellDidSelected = {
            HCHospitalListViewController.push(BaseWebViewController.self,
                                              ["url": APIAssistance.drugActivityDetails(with: $0.id),
                                               "title":$0.medicineName])
        }
        
        container.beginSearch = { [unowned self] in self.viewModel.keyWordsFilterSubject.onNext($0) }
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
