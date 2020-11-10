//
//  HCExpertConsultationController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCExpertConsultationController: BaseViewController {

    private var viewModel: HCExpertConsultationViewModel!
    private var containerView: HCExpertConsultationContainer!
    
    override func setupUI() {
        navigationItem.title = "专家问诊"
        
        containerView = HCExpertConsultationContainer.init(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.cellDidSelected = { [unowned self] in
            let url = APIAssistance.consultationHome(with: $0.id, unitId: $0.unitId)
            self.navigationController?.pushViewController(BaseWebViewController.createWeb(url: url,
                                                                                          title: $0.name,
                                                                                          needUnitId: false),
                                                          animated: true)
        }
        
        containerView.menuSelect = { [weak self] in
            switch $0 {
            case 0:
                let areaSelectedCtrk = HCAreaSelectedViewController()
                self?.addChild(areaSelectedCtrk)
                self?.view.addSubview(areaSelectedCtrk.view)
                
                areaSelectedCtrk.cityClicked = { [weak self] in self?.viewModel.areaFilterSubject.onNext($0) }
            case 1:
                let listFilterCtrl = HCListFilterViewController.init(mode: .sorted)
                self?.addChild(listFilterCtrl)
                self?.view.addSubview(listFilterCtrl.view)
                
                listFilterCtrl.commitCallBack = { [weak self] in self?.viewModel.sortedFilterSubject.onNext($0?.title ?? "") }
            case 2:
                let listFilterCtrl = HCListFilterViewController.init(mode: .consultType)
                self?.addChild(listFilterCtrl)
                self?.view.addSubview(listFilterCtrl.view)
                
                listFilterCtrl.commitCallBack = { [weak self] in self?.viewModel.consultTypeFilterSubject.onNext($0?.title ?? "") }
            default:
                break
            }
        }
    }
    
    override func rxBind() {
        viewModel = HCExpertConsultationViewModel()
        containerView.collectionView.prepare(viewModel)

        viewModel.headerDataSignal
            .subscribe(onNext: { [weak self] in
                self?.containerView.setupHeader(bannberDatas: $0.0,
                                                statisticsDoctorHopitalModel: $0.1,
                                                doctorListDatas: $0.2,
                                                slideMenuData: $0.3)
            })
            .disposed(by: disposeBag)
        
        viewModel.datasource.asDriver()
            .drive(onNext: { [weak self] in self?.containerView.colDatasource = $0 })
            .disposed(by: disposeBag)
        
        viewModel.slideDataSignal
            .subscribe(onNext: { [weak self] in self?.containerView.reloadSlideMenuData(slideMenuData: $0) })
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
        
        containerView.collectionView.headerRefreshing()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
