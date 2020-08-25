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
        searchBar.searchPlaceholder = "搜索"
        searchBar.leftItemTitle = "试管婴儿"
        searchBar.rightItemIcon = "nav_message"
        searchBar.inputBackGroundColor = .white
        searchBar.leftItelColor = .white
        searchBar.backgroundColor = RGB(255, 79, 120)
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
        containerView.articleClicked = { [weak self] _ in
            PrintLog("点击")
//            let webVC = BaseWebViewController()
//            webVC.url = $0.picPath
//            self?.navigationController?.pushViewController(webVC, animated: true)
        }
        
        containerView.funcItemClicked = { [weak self] in self?.functionMenuClicked(functionModel: $0) }
        
        containerView.cmsRecommendItemClicked = { [weak self] in
            let webVC = BaseWebViewController()
            webVC.url = APIAssistance.link(with: $0.id)
            webVC.title = $0.title
            self?.navigationController?.pushViewController(webVC, animated: true)
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
            searchBar.safeArea = view.safeAreaInsets
        } else {
            searchBar.frame = .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + 20)
            searchBar.safeArea = .init(top: 20, left: 0, bottom: 0, right: 0)
        }

        containerView.frame = view.bounds
    }
}

extension HCHomeViewController {
    
    private func functionMenuClicked(functionModel: HCFunctionsMenuModel) {
        if functionModel.primordial == 1 && functionModel.name == "专家问诊" {
            navigationController?.pushViewController(HCExpertConsultationController(), animated: true)
            return
        }
        
        let webVC = BaseWebViewController()
        webVC.url = functionModel.functionUrl
        webVC.title = functionModel.name
        navigationController?.pushViewController(webVC, animated: true)
    }
}
