//
//  HCSearchViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2019/10/3.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class HCSearchViewModel: RefreshVM<HCSearchDataProtocol> {
        
    private var menuPageListData: [HCsearchModule: [HCSearchDataProtocol]] = [:]
    // 记录当前第几页数据
    private var module: HCsearchModule = .doctor

    public let keyWordObser = Variable("")

    public let expertDataSignal = PublishSubject<[HCSearchDataProtocol]>()
    public let realTimeDataSignal = PublishSubject<[HCSearchDataProtocol]>()
    public let courseDataSignal = PublishSubject<[HCSearchDataProtocol]>()
    public let liveVideoDataSignal = PublishSubject<[HCSearchDataProtocol]>()
    /// 绑定当前滑动到哪个栏目
    public let currentPageObser = Variable(HCsearchModule.doctor)

    /// 关键字搜索 - 是否添加到本地数据库
    public let requestSearchSubject = PublishSubject<Bool>()
    /// 清除本地缓存记录
    public let clearSearchRecordSubject = PublishSubject<Void>()
    public let selectedSearchRecordSubject = PublishSubject<String>()

    /// 本地搜索记录
    public let searchRecordsObser = Variable([TYSearchSectionModel]())
    
    override init() {
        super.init()
                
        TYSearchRecordModel.selected { [weak self] records in
            self?.searchRecordsObser.value = TYSearchSectionModel.recordsCreate(datas: records)
        }
        
        currentPageObser.asDriver()
            .drive(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.module = $0
                if strongSelf.menuPageListData.keys.contains($0) == true {
                    switch $0 {
                    case .doctor:
                        strongSelf.expertDataSignal.onNext(strongSelf.menuPageListData[$0]!)
                    case .article:
                        strongSelf.realTimeDataSignal.onNext(strongSelf.menuPageListData[$0]!)
                    case .course:
                        strongSelf.courseDataSignal.onNext(strongSelf.menuPageListData[$0]!)
                    case .live:
                        strongSelf.liveVideoDataSignal.onNext(strongSelf.menuPageListData[$0]!)
                    }
                }else {
                    strongSelf.requestData(true)
                }
            })
            .disposed(by: disposeBag)
                
        requestSearchSubject
            .subscribe(onNext: { [unowned self] cache in
                if cache { self.cacheSearchRecord() }
                self.requestData(true)
            })
            .disposed(by: disposeBag)
        
        clearSearchRecordSubject
            .subscribe(onNext: { [weak self] in
                self?.clearSearchRecords()
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
        
        selectedSearchRecordSubject
            .subscribe(onNext: { [unowned self] keyWord in
                self.keyWordObser.value = keyWord
                self.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        updatePage(for: module.rawValue, refresh: refresh)
        
        if !menuPageListData.keys.contains(module) {
            menuPageListData[module] = []
        }
        
        let requestProvider = HCProvider.request(.search(moduleType: module,
                                                         searchWords: keyWordObser.value,
                                                         pageSize: pageSize(for: module.rawValue),
                                                         pageNum: currentPage(for: module.rawValue)))
        
        switch module {
        case .doctor:
            requestProvider
                .map(model: HCDoctorListModel.self)
                .subscribe(onSuccess: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.updateRefresh(refresh: refresh,
                                             models: $0.records,
                                             dataModels: &strongSelf.menuPageListData[strongSelf.module]!,
                                             pages: $0.total,
                                             pageKey: strongSelf.module.rawValue)
                    strongSelf.expertDataSignal.onNext(strongSelf.menuPageListData[strongSelf.module]!)
                    },
                           onError: { [weak self] _ in
                            guard let strongSelf = self else { return }
                            self?.revertCurrentPageAndRefreshStatus(pageKey: strongSelf.module.rawValue)
                })
                .disposed(by: disposeBag)
        case .article:
            requestProvider
                .map(model: HCRealTimeListModel.self)
                .subscribe(onSuccess: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.updateRefresh(refresh: refresh,
                                             models: $0.records,
                                             dataModels: &strongSelf.menuPageListData[strongSelf.module]!,
                                             pages: $0.total,
                                             pageKey: strongSelf.module.rawValue)
                    strongSelf.realTimeDataSignal.onNext(strongSelf.menuPageListData[strongSelf.module]!)
                    },
                           onError: { [weak self] _ in
                            guard let strongSelf = self else { return }
                            self?.revertCurrentPageAndRefreshStatus(pageKey: strongSelf.module.rawValue)
                })
                .disposed(by: disposeBag)
        case .course:
            requestProvider
                .map(model: HCCourseListModel.self)
                .subscribe(onSuccess: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.updateRefresh(refresh: refresh,
                                             models: $0.records,
                                             dataModels: &strongSelf.menuPageListData[strongSelf.module]!,
                                             pages: $0.total,
                                             pageKey: strongSelf.module.rawValue)
                    strongSelf.courseDataSignal.onNext(strongSelf.menuPageListData[strongSelf.module]!)
                    },
                           onError: { [weak self] _ in
                            guard let strongSelf = self else { return }
                            self?.revertCurrentPageAndRefreshStatus(pageKey: strongSelf.module.rawValue)
                })
                .disposed(by: disposeBag)
        case .live:
            requestProvider
                .map(model: HCLiveVideoListModel.self)
                .subscribe(onSuccess: { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.updateRefresh(refresh: refresh,
                                             models: $0.records,
                                             dataModels: &strongSelf.menuPageListData[strongSelf.module]!,
                                             pages: $0.total,
                                             pageKey: strongSelf.module.rawValue)
                    strongSelf.liveVideoDataSignal.onNext(strongSelf.menuPageListData[strongSelf.module]!)
                    },
                           onError: { [weak self] _ in
                            guard let strongSelf = self else { return }
                            self?.revertCurrentPageAndRefreshStatus(pageKey: strongSelf.module.rawValue)
                })
                .disposed(by: disposeBag)
        }
    }

}

extension HCSearchViewModel {
        
    private func cacheSearchRecord() {
        if keyWordObser.value.count > 0 {
            var datas = searchRecordsObser.value
            if datas.count == 1 {
                let sectionModel = TYSearchSectionModel.creatSection(sectionTitle: "搜索记录", showDelete: true)
                sectionModel.addRecord(keyWord: keyWordObser.value)
                datas.insert(sectionModel, at: 0)
                
            }else {
                if datas.first?.recordDatas.contains(where: { [unowned self] in $0.keyWord == self.keyWordObser.value }) == false {
                    datas.first!.addRecord(keyWord: keyWordObser.value)
                    searchRecordsObser.value = datas
                }
            }
                        
            TYSearchRecordModel.insert(keyWord: keyWordObser.value)
        }
    }
    
    private func clearSearchRecords() {
        var datas = searchRecordsObser.value
        if datas.count > 1 {
            datas.remove(at: 0)
        }
        
        searchRecordsObser.value = datas
        
        TYSearchRecordModel.clearSearchRecords()
    }
}
