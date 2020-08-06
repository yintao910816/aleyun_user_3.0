//
//  HCExpertConsultViewController.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/28.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit

class HCExpertConsultViewController: BaseViewController {

    @IBOutlet weak var navSearchBar: TYSearchBar!
    @IBOutlet weak var listMenuView: TYListMenuView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navHeightCns: NSLayoutConstraint!
    
    private var isFirstLoad: Bool = true
    
    private var cityFilterView: TYCityFilterView!
    private var filiterView: TYFiliterView!
    
    private var viewModel: HCExpertConsultViewModel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        navHeightCns.constant += LayoutSize.topVirtualArea_1
        
        navSearchBar.tfBgColor = RGB(247, 247, 247)
        navSearchBar.coverButtonEnable = false
        navSearchBar.leftItemIcon = "navigationButtonReturnClick"
        navSearchBar.searchPlaceholder = "搜索"
        navSearchBar.returnKeyType = .search
        navSearchBar.tfSearchIcon = "nav_search_gray"
        navSearchBar.backgroundColor = .white
        
        navSearchBar.leftItemTapBack = { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        }
        
        navSearchBar.beginSearch = { [weak self] _ in
            self?.viewModel.requestSearchSubject.onNext(Void())
        }

        tableView.rowHeight = HCConsultListCell_Height
        tableView.register(HCConsultListCell.self, forCellReuseIdentifier: HCConsultListCell_idetifier)
        
        listMenuView.selectedCallBack = { [weak self] type in
            switch type {
            case .city:
                self?.cityFilterView.excuteAnimotion(true)
            case .filiter:
                self?.filiterView.excuteAnimotion(true)
            default:
                self?.viewModel.filiterOpTypeSubject.onNext(type.rawValue)
            }
        }
        
        cityFilterView = TYCityFilterView.init(frame: view.bounds)
        view.insertSubview(cityFilterView, belowSubview: listMenuView)
        cityFilterView.didSelectedCallBack = { [weak self] in
            self?.listMenuView.cityChange(title: $0.name)
            self?.viewModel.filiterCitySubject.onNext($0)
            self?.cityFilterView.excuteAnimotion(true)
        }
        
        cityFilterView.snp.makeConstraints{
            $0.left.right.bottom.equalTo(0)
            $0.top.equalTo(listMenuView.snp.bottom)
        }
        cityFilterView.excuteAnimotion(false)
        
        filiterView = TYFiliterView.init(frame: view.bounds)
        filiterView.commitCallBack = { [unowned self] in
            self.viewModel.filiterCommitSubject.onNext($0)
        }
        view.addSubview(filiterView)
        view.bringSubviewToFront(filiterView)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.isFirstLoad = false
        }
    }
    
    override func rxBind() {
        viewModel = HCExpertConsultViewModel()
        listMenuView.setData(listData: viewModel.getListMenuData())
        
        viewModel.datasource.asDriver()
            .drive(tableView.rx.items(cellIdentifier: HCConsultListCell_idetifier, cellType: HCConsultListCell.self)) { _,model,cell  in
                cell.model = model
                cell.consultCallBack = {
                    HCHelper.pushH5(href: "\(H5Type.doctorCs.getLocalUrl())&userId=\($0.userId)")
                }
        }
        .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(HCDoctorItemModel.self)
            .subscribe(onNext: {
                let ctrl = HCDoctorHomeController()
                ctrl.prepare(parameters: HCDoctorHomeController.preprare(model: $0))
                self.navigationController?.pushViewController(ctrl, animated: true)
            })
            .disposed(by: disposeBag)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // 上下拉刷新绑定
        tableView.prepare(viewModel, showFooter: true)
        tableView.headerRefreshing()
        
        viewModel.allCitysDataObser.asDriver()
            .drive(cityFilterView.datasource)
            .disposed(by: disposeBag)
        
        navSearchBar.textObser
            .bind(to: viewModel.searchTextObser)
            .disposed(by: disposeBag)
        
        viewModel.reloadSubject.onNext(Void())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLoad && filiterView.width > 0 {
            filiterView.excuteAnimotion(false)
        }
    }
}

extension HCExpertConsultViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        navSearchBar.resignSearchFirstResponder()
    }
}
