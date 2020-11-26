//
//  HCHospitalListViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/26.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCHospitalListViewController: BaseViewController, VMNavigation {

    private var viewModel: HCHospitalListViewModel!
    private var container: HCHospitalListContainer!
    
    override func setupUI() {
        navigationItem.title = "生殖中心大全"
        
        container = HCHospitalListContainer.init(frame: view.bounds)
        view.addSubview(container)
        
        container.menuSelect = { [weak self] in
            switch $0 {
            case 0:
                let areaSelectedCtrk = HCAreaSelectedViewController()
                self?.addChild(areaSelectedCtrk)
                self?.view.addSubview(areaSelectedCtrk.view)
                
                areaSelectedCtrk.cityClicked = { [weak self] in self?.viewModel.areaFilterSubject.onNext($0) }
            case 1:
                let listFilterCtrl = HCListFilterViewController.init(mode: .szzx)
                self?.addChild(listFilterCtrl)
                self?.view.addSubview(listFilterCtrl.view)
                
                listFilterCtrl.commitCallBack = { [weak self] in self?.viewModel.levelFilterSubject.onNext($0?.title ?? "") }
            default:
                break
            }
        }
        
        container.cellDidSelected = {
            HCHospitalListViewController.push(BaseWebViewController.self,
                                              ["url": APIAssistance.hospitalDetails(with: $0.id), "title":$0.name])
        }
        
        container.beginSearch = { [unowned self] in self.viewModel.keyWordsFilterSubject.onNext($0) }
    }
    
    override func rxBind() {
        viewModel = HCHospitalListViewModel()
        
        container.tableView.prepare(viewModel, showFooter: false)
        
        viewModel.slideDataSignal
            .subscribe(onNext: { [weak self] in self?.container.menuItems = $0 })
            .disposed(by: disposeBag)
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] in self?.container.hospitalDatas = $0 })
            .disposed(by: disposeBag)
                
        viewModel.reloadSubject.onNext(Void())
        
        container.tableView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}
