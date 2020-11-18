//
//  HCMyConsultViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/22.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

enum HCMyConsultMode: Int {
    case picConsult = 1
    case videoConsult = 2
    case cloudClinic = 3
}

class HCMyConsultViewModel: RefreshVM<HCConsultModelAdapt> {
    
    private var menuPageListData: [HCMyConsultMode: [HCConsultModelAdapt]] = [:]
    // 记录当前第几页数据
    private var module: HCMyConsultMode = .picConsult

    public let changeMenuSignal = PublishSubject<Int>()
    
    override init() {
        super.init()
        
        changeMenuSignal
            .subscribe(onNext: { [unowned self] in
                let mode = HCMyConsultMode(rawValue: $0 + 1) ?? HCMyConsultMode.picConsult
                self.module = mode
                if self.menuPageListData.keys.contains(mode) {
                    self.datasource.value = self.menuPageListData[mode]!
                    self.isEmptyContentObser.value = self.datasource.value.count == 0
                }else {
                    self.requestData(true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    public var currentMode: HCMyConsultMode { get { return module } }
    
    override func requestData(_ refresh: Bool) {
        let cacheKey: String = "\(module.rawValue)"
        updatePage(for: cacheKey, refresh: refresh)
        
        if !menuPageListData.keys.contains(module) {
            menuPageListData[module] = []
        }
        
        switch module {
        case .picConsult:
            HCProvider.request(.myConsult(consultType: 1, pageSize: 10, pageNum: 1, status: nil))
                .map(result: HCPicConsultListModel.self)
                .subscribe(onSuccess: { [weak self] data in
                    guard let strongSelf = self else { return }
                    strongSelf.updateRefresh(refresh: refresh,
                                             models: data.data?.records,
                                             dataModels: &strongSelf.menuPageListData[strongSelf.module]!,
                                             pages: data.data?.pages ?? 0,
                                             pageKey: cacheKey)
                    strongSelf.datasource.value = strongSelf.menuPageListData[strongSelf.module]!
                }) { [weak self] _ in
                    self?.revertCurrentPageAndRefreshStatus(pageKey: cacheKey)
            }
            .disposed(by: disposeBag)
        case .videoConsult:
            HCProvider.request(.myConsult(consultType: 2, pageSize: 10, pageNum: 1, status: nil))
                .map(result: HCVideoConsultListModel.self)
                .subscribe(onSuccess: { [weak self] data in
                    guard let strongSelf = self else { return }
                    strongSelf.updateRefresh(refresh: refresh,
                                             models: data.data?.records,
                                             dataModels: &strongSelf.menuPageListData[strongSelf.module]!,
                                             pages: data.data?.pages ?? 0,
                                             pageKey: cacheKey)
                    strongSelf.datasource.value = strongSelf.menuPageListData[strongSelf.module]!
                }) { [weak self] _ in
                    self?.revertCurrentPageAndRefreshStatus(pageKey: cacheKey)
            }
            .disposed(by: disposeBag)

        case .cloudClinic:
            HCProvider.request(.myConsult(consultType: 3, pageSize: 10, pageNum: 1, status: nil))
                .map(result: HCCloudClinicConsultListModel.self)
                .subscribe(onSuccess: { [weak self] data in
                    guard let strongSelf = self else { return }
                    strongSelf.updateRefresh(refresh: refresh,
                                             models: data.data?.records,
                                             dataModels: &strongSelf.menuPageListData[strongSelf.module]!,
                                             pages: data.data?.pages ?? 0,
                                             pageKey: cacheKey)
                    strongSelf.datasource.value = strongSelf.menuPageListData[strongSelf.module]!
                }) { [weak self] _ in
                    self?.revertCurrentPageAndRefreshStatus(pageKey: cacheKey)
            }
            .disposed(by: disposeBag)
        }
    }
    
}
