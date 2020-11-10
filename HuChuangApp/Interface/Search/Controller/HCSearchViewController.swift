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

    private var pageIds: [HCsearchModule] = [.doctor, .article, .course, .live]
    
    private var viewModel: HCSearchViewModel!

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        view.backgroundColor = .white
        
        searchBar = TYSearchBar.init(frame: .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + (UIDevice.current.isX ? 0 : 24)))
        searchBar.coverButtonEnable = false
        searchBar.searchPlaceholder = "搜索"
        searchBar.rightItemTitle = "取消"
        searchBar.leftItemIcon = "navigationButtonReturnClick"
        searchBar.inputBackGroundColor = RGB(240, 240, 240)
        searchBar.hasBottomLine = true
        searchBar.returnKeyType = .search
        view.addSubview(searchBar)
        
        searchBar.leftItemTapBack = { [weak self] in self?.navigationController?.popViewController(animated: true) }
        
        searchBar.rightItemTapBack = { [weak self] in
            self?.searchRecordView.isHidden = false
            self?.viewModel.keyWordObser.value = ""
            self?.searchBar.reloadInput(content: nil)
        }

        searchBar.beginSearch = { [weak self] content in
            self?.searchRecordView.isHidden = true
            self?.viewModel.requestSearchSubject.onNext(true)
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
            self?.viewModel.selectedSearchRecordSubject.onNext($0)
        }
        
        expertCtrl.cellDidselected = { [weak self] in
            let url = APIAssistance.consultationHome(with: $0.id, unitId: $0.unitId)
            self?.navigationController?.pushViewController(BaseWebViewController.createWeb(url: url,
                                                                                           title: "咨询",
                                                                                           needUnitId: false),
                                                           animated: true)
        }
        
        realTimeCtrl.cellSelectedCallBack = { [weak self] in
            let url = APIAssistance.link(with: $0.id)
            self?.navigationController?.pushViewController(BaseWebViewController.createWeb(url: url,
                                                                                           title: $0.title),
                                                           animated: true)
        }
    }
    
    override func rxBind() {
        viewModel = HCSearchViewModel()
        
        expertCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)
        realTimeCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)
        courseCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)
        liveVideoCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)

        searchBar.textObser
            .bind(to: viewModel.keyWordObser)
            .disposed(by: disposeBag)
        
        viewModel.searchRecordsObser.asDriver()
            .drive(onNext: { [weak self] in
                self?.searchRecordView.recordDatasource = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.expertDataSignal
            .subscribe(onNext: { [weak self] in self?.expertCtrl.reloadData(data: $0) })
            .disposed(by: disposeBag)
        
        viewModel.realTimeDataSignal
            .subscribe(onNext: { [weak self] in self?.realTimeCtrl.reloadData(data: $0) })
            .disposed(by: disposeBag)

        viewModel.courseDataSignal
            .subscribe(onNext: { [weak self] in self?.courseCtrl.reloadData(data: $0) })
            .disposed(by: disposeBag)

        viewModel.liveVideoDataSignal
            .subscribe(onNext: { [weak self] in self?.liveVideoCtrl.reloadData(data: $0) })
            .disposed(by: disposeBag)

        slideCtrl.pageScrollSubject
            .map{ [unowned self] in self.pageIds[$0] }
            .bind(to: viewModel.currentPageObser)
            .disposed(by: disposeBag)
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
        
        slideCtrl.view.frame = .init(x: 0, y: searchBar.frame.maxY, width: view.width, height: view.height - searchBar.frame.maxY)
        searchRecordView.frame = .init(x: 0, y: searchBar.frame.maxY, width: view.width, height: view.height - searchBar.frame.maxY)
    }

}
