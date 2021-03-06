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
    private var searchBar: TYSearchBar!

    private var viewModel: HCHomeViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        edgesForExtendedLayout = .all
        
        searchBar = TYSearchBar.init(frame: .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight))
        searchBar.backgroundColor = RGB(255, 79, 120)
        searchBar.viewConfig = TYSearchBarConfig.createHomeSearch()
        view.addSubview(searchBar)
        
        searchBar.tapInputCallBack = { [unowned self] in
            self.navigationController?.pushViewController(HCSearchViewController(), animated: true)
        }
        
        searchBar.rightItemTapBack = { [weak self] in
            self?.navigationController?.pushViewController(HCMessageViewController(), animated: true)
        }
        
        containerView = HCHomeViewContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.insertSubview(containerView, belowSubview: searchBar)
        
        containerView.menuChanged = { [weak self] in self?.viewModel.articleTypeChangeSignal.onNext($0) }
        containerView.articleClicked = { [weak self] in self?.viewModel.articleDetailSignal.onNext($0) }
        
        containerView.funcItemClicked = { [weak self] in self?.functionMenuClicked(functionModel: $0) }
        
        containerView.cmsRecommendItemClicked = { [weak self] in
            let url = APIAssistance.link(with: $0.id)
            self?.navigationController?.pushViewController(BaseWebViewController.createWeb(url: url,
                                                                                           title: $0.title),
                                                           animated: true)
        }
    }
    
    override func rxBind() {
        viewModel = HCHomeViewModel()
          
        viewModel.functionsMenuSignal.asDriver()
            .drive(onNext: { [weak self] in self?.containerView.reloadData(menuItems: $0.0, cmsChanelListModel: $0.1, cmsModes: $0.2, page: $0.3) })
            .disposed(by: disposeBag)

        viewModel.articleDataSignal
            .subscribe(onNext: { [weak self] in self?.containerView.reloadArticleDatas(datas: $0.0, page: $0.1) })
            .disposed(by: disposeBag)
                
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            searchBar.frame = .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + view.safeAreaInsets.top)
        } else {
            searchBar.frame = .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + LayoutSize.statusBarHeight)
        }

        containerView.frame = view.bounds
    }
}

extension HCHomeViewController {
    
    private func functionMenuClicked(functionModel: HCFunctionsMenuModel) {
        
        // 专家咨询
        if functionModel.primordial == 1 && functionModel.code == "ZJWZ" {
            navigationController?.pushViewController(HCExpertConsultationController(), animated: true)
            return
        }
        
        // 试管百科
        if functionModel.primordial == 1 && functionModel.code == "SGBK" {
            navigationController?.pushViewController(HCTestTubeViewController(), animated: true)
            return
        }
        
        // 生殖中心
        if functionModel.primordial == 1 && functionModel.code == "SZZX" {
            navigationController?.pushViewController(HCHospitalListViewController(), animated: true)
            return
        }
        
        // 药品百科
        if functionModel.primordial == 1 && functionModel.code == "YPBK" {
            navigationController?.pushViewController(HCMedicineViewController(), animated: true)
            return
        }

        if functionModel.functionUrl.contains("underdev") && !functionModel.functionUrl.contains("http") {
//            HCHelper.pushLocalH5(type: .underDev)
            navigationController?.pushViewController(HCUnderDevController.ctrlCreat(navTitle: functionModel.name),
                                                     animated: true)
        }else {
            navigationController?.pushViewController(BaseWebViewController.createWeb(url: functionModel.functionUrl,
                                                                                     title: functionModel.name),
                                                     animated: true)
        }
    }
}
