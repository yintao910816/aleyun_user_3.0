//
//  HCCircleViewController.swift
//  HuChuangApp
//
//  Created by sw on 02/02/2019.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCClassRoomViewController: BaseViewController {

    private var viewModel: HCClassRoomViewModel!
    
    private var slideCtrl: TYSlideMenuController!
    private var searchBar: TYSearchBar!

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        view.backgroundColor = .white
                       
        slideCtrl = TYSlideMenuController()
        addChild(slideCtrl)
        view.addSubview(slideCtrl.view)
        
        searchBar = TYSearchBar.init(frame: .init(x: 0, y: 0, width: view.width, height: TYSearchBar.baseHeight))
        searchBar.searchPlaceholder = "搜索"
        searchBar.rightItemTitle = "取消"
        searchBar.inputBackGroundColor = RGB(245, 245, 245)
        view.addSubview(searchBar)
        
        searchBar.tapInputCallBack = { [unowned self] in
            self.navigationController?.pushViewController(HCSearchViewController(), animated: true)
        }
        
        searchBar.rightItemTapBack = {

        }

        
        slideCtrl.pageScroll = { [weak self] page in
            self?.viewModel.requestTodayListSubject.onNext(page)
        }
    }
    
    override func rxBind() {
        viewModel = HCClassRoomViewModel.init()
        
        viewModel.menuItemData
            .subscribe(onNext: { [weak self] menus in
                guard let strongSelf = self else { return }
                
                var ctrls: [HCClassRoomItemController] = []
                for idx in 0..<menus.count {
                    let ctrl = HCClassRoomItemController()
                    ctrl.pageIdx = idx
                    ctrl.view.backgroundColor = .white
                    ctrl.bind(viewModel: strongSelf.viewModel, canRefresh: true, canLoadMore: true, isAddNoMoreContent: false)
                    ctrl.didSelectedCallBack = { [weak self] in
                        let ctrl = HCArticleDetailViewController()
                        ctrl.prepare(parameters: HCArticleDetailViewController.preprare(model: $0))
                        self?.navigationController?.pushViewController(ctrl, animated: true)
                    }
                    
                    ctrls.append(ctrl)
                }
                
                strongSelf.slideCtrl.menuItems = menus
                strongSelf.slideCtrl.menuCtrls = ctrls
            })
            .disposed(by: disposeBag)
        
        viewModel.pageListData
            .subscribe(onNext: { [weak self] data in
                self?.slideCtrl.reloadList(listMode: data.0, page: data.1)
            })
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
        
        slideCtrl.view.frame = .init(x: 0, y: searchBar.frame.maxY, width: view.width, height: view.height - searchBar.frame.maxY)
    }
}
