//
//  HCExpertConsultationController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCExpertConsultationController: BaseViewController,VMNavigation {

    private var viewModel: HCExpertConsultationViewModel!
    private var containerView: HCExpertConsultationContainer!
    
    override func setupUI() {
        navigationItem.title = "专家咨询"
        
        containerView = HCExpertConsultationContainer.init(frame: view.bounds)
        view.addSubview(containerView)
        
        containerView.cellDidSelected = {
            let params = HCShareWebViewController.configParameters(mode: .doctor,
                                                                   model: HCShareDataModel.transformDoctorModel(model: $0),
                                                                   needUnitId: false,
                                                                   isAddRightItems: $0.isOpenAnyConsult)
            HCExpertConsultationController.push(HCShareWebViewController.self,
                                                params)
        }
        
        containerView.menuSelect = { [weak self] in
            switch $0 {
            case 0:
                let areaSelectedCtrk = HCAreaSelectedViewController()
                self?.addChild(areaSelectedCtrk)
                self?.view.addSubview(areaSelectedCtrk.view)
                
                areaSelectedCtrk.cityClicked = { [weak self] in self?.viewModel.areaFilterSubject.onNext($0) }
            case 1:
                let listFilterCtrl = HCListFilterViewController.init(mode: .sorted, selectedIdentifier: self?.viewModel.sortedIdentifier)
                self?.addChild(listFilterCtrl)
                self?.view.addSubview(listFilterCtrl.view)
                
                listFilterCtrl.commitCallBack = { [weak self] in self?.viewModel.sortedFilterSubject.onNext($0?.title ?? "") }
            case 2:
                let listFilterCtrl = HCListFilterViewController.init(mode: .consultType, selectedIdentifier: self?.viewModel.consultTypeIdentifier)
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
        containerView.collectionView.prepare(viewModel, isAddNoMoreContent: false)

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
