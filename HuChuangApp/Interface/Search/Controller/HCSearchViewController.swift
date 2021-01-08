//
//  HCSearchViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/10/2.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import RxDataSources

class HCSearchViewController: BaseViewController {

    private var searchBar: TYSearchBar!
    private var searchRecordView: TYSearchRecordView!
    private var slideCtrl: TYSlideMenuController!
    
    private var expertCtrl: HCExpertViewController!
    private var realTimeCtrl: HCRealTimeViewController!
    private var courseCtrl: HCCourseViewController!
    private var liveVideoCtrl: HCLiveVideoViewController!
    
    private var viewModel: HCSearchViewModel!

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        view.backgroundColor = .white
        
        searchBar = TYSearchBar.init(frame: .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + (UIDevice.current.isX ? 0 : 24)))
        searchBar.coverButtonEnable = false
        searchBar.hasBottomLine = true
        searchBar.viewConfig = TYSearchBarConfig.createSearch()
        view.addSubview(searchBar)
        
        searchBar.leftItemTapBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        
        searchBar.rightItemTapBack = { [weak self] in
            self?.searchRecordView.isHidden = false
            self?.searchBar.reloadInput(content: nil)
        }

        searchBar.beginSearch = { [weak self] in
            self?.searchRecordView.isHidden = true
            self?.viewModel.cacheSearchSubject.onNext($0)

            self?.expertCtrl.collectionView.headerRefreshing()
            self?.realTimeCtrl.collectionView.headerRefreshing()
            self?.courseCtrl.collectionView.headerRefreshing()
            self?.liveVideoCtrl.collectionView.headerRefreshing()
        }
        
        searchBar.willSearch = { [weak self] in
            self?.searchRecordView.isHidden = false
        }
        
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        expertCtrl = HCExpertViewController()
        realTimeCtrl = HCRealTimeViewController()
        courseCtrl = HCCourseViewController()
        liveVideoCtrl = HCLiveVideoViewController()

        slideCtrl.menuItems = TYSlideItemModel.createSearchResultData()
        slideCtrl.menuCtrls = [expertCtrl, realTimeCtrl, courseCtrl, liveVideoCtrl]

        searchRecordView = TYSearchRecordView.init(frame: .init(x: 0, y: searchBar.frame.maxY, width: view.width, height: searchBar.frame.maxY))
        searchRecordView.isHidden = false
        view.addSubview(searchRecordView)
        
        searchRecordView.clearRecordsCallBack = { [weak self] in
            self?.searchBar.reloadInput(content: nil)
            self?.viewModel.clearSearchRecordSubject.onNext(Void())
        }
        searchRecordView.selectedCallBack = { [weak self] in
            self?.searchRecordView.isHidden = true
            self?.searchBar.resignSearchFirstResponder()
            self?.searchBar.reloadInput(content: $0)

            self?.viewModel.cacheSearchSubject.onNext($0)

            self?.expertCtrl.viewModel.keyWordObser.value = $0
            self?.realTimeCtrl.viewModel.keyWordObser.value = $0
            self?.courseCtrl.viewModel.keyWordObser.value = $0
            self?.liveVideoCtrl.viewModel.keyWordObser.value = $0

            self?.expertCtrl.collectionView.headerRefreshing()
            self?.realTimeCtrl.collectionView.headerRefreshing()
            self?.courseCtrl.collectionView.headerRefreshing()
            self?.liveVideoCtrl.collectionView.headerRefreshing()
        }
    }
    
    override func rxBind() {
        viewModel = HCSearchViewModel()
        
        searchBar.textObser
            .bind(to: expertCtrl.viewModel.keyWordObser)
            .disposed(by: disposeBag)
        
        searchBar.textObser
            .bind(to: realTimeCtrl.viewModel.keyWordObser)
            .disposed(by: disposeBag)

        searchBar.textObser
            .bind(to: courseCtrl.viewModel.keyWordObser)
            .disposed(by: disposeBag)

        searchBar.textObser
            .bind(to: liveVideoCtrl.viewModel.keyWordObser)
            .disposed(by: disposeBag)
        
        viewModel.searchRecordsObser.asDriver()
            .drive(onNext: { [weak self] in
                self?.searchRecordView.recordDatasource = $0
            })
            .disposed(by: disposeBag)
        
        expertCtrl.collectionView.rx.modelSelected(HCDoctorListItemModel.self)
            .subscribe(onNext: { 
                let params = HCShareWebViewController.configParameters(mode: .doctor,
                                                                       model: HCShareDataModel.transformDoctorModel(model: $0),
                                                                       needUnitId: false,
                                                                       isAddRightItems: $0.isOpenAnyConsult)
                HCExpertConsultationController.push(HCShareWebViewController.self,
                                                    params)
            })
            .disposed(by: disposeBag)
        
        realTimeCtrl.collectionView.rx.modelSelected(HCRealTimeListItemModel.self)
            .map({ $0.id })
            .bind(to: viewModel.realTimeSelectedSubject)
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if #available(iOS 11.0, *) {
            searchBar.frame = .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + view.safeAreaInsets.top)
        } else {
            searchBar.frame = .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + LayoutSize.statusBarHeight)
        }
        
        slideCtrl.view.frame = .init(x: 0, y: searchBar.frame.maxY, width: view.width, height: view.height - searchBar.frame.maxY)
        searchRecordView.frame = .init(x: 0, y: searchBar.frame.maxY, width: view.width, height: view.height - searchBar.frame.maxY)
    }

}
