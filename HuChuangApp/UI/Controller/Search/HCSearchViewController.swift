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
    
    private var pageIds: [HCsearchModule] = [.all, .doctor, .course, .article]
    
    private var viewModel: HCSearchViewModel!

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        view.backgroundColor = .white
        
        searchBar = TYSearchBar.init(frame: .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight + (UIDevice.current.isX ? 0 : 24)))
        searchBar.coverButtonEnable = false
        searchBar.searchPlaceholder = "搜索症状/疾病/药品/医生/科室"
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
    }
    
    override func rxBind() {
        viewModel = HCSearchViewModel()
        
        searchBar.textObser
            .bind(to: viewModel.keyWordObser)
            .disposed(by: disposeBag)
        
        viewModel.searchRecordsObser.asDriver()
            .drive(onNext: { [weak self] in
                self?.searchRecordView.recordDatasource = $0
            })
            .disposed(by: disposeBag)
        
        let allCtrl = HCSearchAllViewController()
        allCtrl.pageIdx = 0
        allCtrl.view.backgroundColor = .white
//        allCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: false, isAddNoMoreContent: false)
        allCtrl.pushH5CallBack = { [unowned self] in
            switch $0.1 {
            case .doctor:
                let ctrl = HCDoctorHomeController()
                ctrl.prepare(parameters: HCDoctorHomeController.preprare(model: HCDoctorItemModel.transform(model: $0.0 as! HCSearchDoctorItemModel)))
                self.navigationController?.pushViewController(ctrl, animated: true)
            case .article, .course:
                let ctrl = HCArticleDetailViewController()
                ctrl.prepare(parameters: HCArticleDetailViewController.preprare(model: HCArticleItemModel.transform(model: $0.0 as! HCSearchArticleItemModel)))
                self.navigationController?.pushViewController(ctrl, animated: true)
            default:
                break
            }
        }
        allCtrl.clickedMoreCallBack = { [unowned self] modul in
            self.slideCtrl.selectedPage(page: self.pageIds.lastIndex(of: modul)!,
                                        needCallBack: false,
                                        needMenuScroll: true)
        }
        
        let doctorCtrl = HCSearchRecommendDoctorViewController()
        doctorCtrl.pageIdx = 1
        doctorCtrl.view.backgroundColor = .white
//        doctorCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)
        doctorCtrl.didSelectedCallBack = { [unowned self] in
            let ctrl = HCDoctorHomeController()
            ctrl.prepare(parameters: HCDoctorHomeController.preprare(model: HCDoctorItemModel.transform(model: $0)))
            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        
        let classCtrl = HCSearchHealthyCourseViewController()
        classCtrl.pageIdx = 2
        classCtrl.view.backgroundColor = .white
//        classCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)
        classCtrl.pushH5CallBack = { [unowned self] _ in
//            let ctrl = HCArticleDetailViewController()
//            ctrl.prepare(parameters: HCArticleDetailViewController.preprare(model: HCArticleItemModel.transform(model: $0)))
//            self.navigationController?.pushViewController(ctrl, animated: true)
        }
        
        let popularScienceCtrl = HCSearchPopularScienceViewController()
        popularScienceCtrl.pageIdx = 3
        popularScienceCtrl.view.backgroundColor = .white
//        popularScienceCtrl.bind(viewModel: viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)
        popularScienceCtrl.pushH5CallBack = { [unowned self] in
            let ctrl = HCArticleDetailViewController()
            ctrl.prepare(parameters: HCArticleDetailViewController.preprare(model: HCArticleItemModel.transform(model: $0)))
            self.navigationController?.pushViewController(ctrl, animated: true)
        }

        slideCtrl.menuItems = TYSlideItemModel.creatSimple(for: ["全部", "医生", "课程", "文章"])
        slideCtrl.menuCtrls = [allCtrl, doctorCtrl, classCtrl, popularScienceCtrl]
        
        viewModel.pageListData
            .subscribe(onNext: { [weak self] data in
                guard let strongSelf = self else { return }
                switch data.4 {
                case .all:
                    strongSelf.slideCtrl.reloadList(listMode: data.0, page: strongSelf.pageIds.lastIndex(of: .all)!)
                    strongSelf.slideCtrl.reloadList(listMode: data.1, page: strongSelf.pageIds.lastIndex(of: .doctor)!)
                    strongSelf.slideCtrl.reloadList(listMode: data.2, page: strongSelf.pageIds.lastIndex(of: .course)!)
                    strongSelf.slideCtrl.reloadList(listMode: data.3, page: strongSelf.pageIds.lastIndex(of: .article)!)
                case .doctor:
                    strongSelf.slideCtrl.reloadList(listMode: data.1, page: strongSelf.pageIds.lastIndex(of: .doctor)!)
                case .course:
                    strongSelf.slideCtrl.reloadList(listMode: data.2, page: strongSelf.pageIds.lastIndex(of: .course)!)
                case .article:
                    strongSelf.slideCtrl.reloadList(listMode: data.3, page: strongSelf.pageIds.lastIndex(of: .article)!)
                }
            })
            .disposed(by: disposeBag)
        
        slideCtrl.pageScrollSubject
            .map{ [unowned self] in self.pageIds[$0] }
            .bind(to: viewModel.currentPageObser)
            .disposed(by: disposeBag)
        
//        slideCtrl.pageScroll = { [weak self] page in
//            guard let strongSelf = self else { return }
//            strongSelf.viewModel.requestSearchListSubject.onNext(strongSelf.pageIds[page])
//        }

//        viewModel.requestSearchListSubject.onNext(.all)
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
