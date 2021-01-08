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

class HCSearchViewModel: BaseViewModel {
        
    /// 文章点击
    public let realTimeSelectedSubject = PublishSubject<String>()

    /// 关键字搜索 - 是否添加到本地数据库
    public let cacheSearchSubject = PublishSubject<String>()
    /// 清除本地缓存记录
    public let clearSearchRecordSubject = PublishSubject<Void>()

    /// 本地搜索记录
    public let searchRecordsObser = Variable([TYSearchSectionModel]())
    
    override init() {
        super.init()
                
        TYSearchRecordModel.selected { [weak self] records in
            self?.searchRecordsObser.value = TYSearchSectionModel.recordsCreate(datas: records)
        }
                        
        cacheSearchSubject
            .subscribe(onNext: { [unowned self] in cacheSearchRecord(content: $0) })
            .disposed(by: disposeBag)
        
        clearSearchRecordSubject
            .subscribe(onNext: { [weak self] in self?.clearSearchRecords() })
            .disposed(by: disposeBag)
                
        realTimeSelectedSubject
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in self.requestArticleDetail(articleId: $0) })
            .disposed(by: disposeBag)
    }

    private func requestArticleDetail(articleId: String) {
        HCProvider.request(.cmsDetail(articleId: articleId))
            .map(model: HCCmsDetailModel.self)
            .subscribe { [weak self] linkM in
                self?.hud.noticeHidden()
                let params = HCShareWebViewController.configParameters(mode: .article, model: HCShareDataModel.transformCmsModel(model: linkM))
                HCHomeViewModel.push(HCShareWebViewController.self, params)
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
    
    private func cacheSearchRecord(content: String) {
        if content.count > 0 {
            var datas = searchRecordsObser.value
            if datas.count == 1 {
                let sectionModel = TYSearchSectionModel.creatSection(sectionTitle: "搜索记录", showDelete: true)
                sectionModel.addRecord(keyWord: content)
                datas.insert(sectionModel, at: 0)
                searchRecordsObser.value = datas
            }else {
                if datas.first?.recordDatas.contains(where: { $0.keyWord == content }) == false {
                    datas.first!.addRecord(keyWord: content)
                    searchRecordsObser.value = datas
                }
            }
                        
            TYSearchRecordModel.insert(keyWord: content)
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

class HCDoctorSearchViewModel: RefreshVM<HCDoctorListItemModel> {
    
    public let keyWordObser = Variable("")

    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.search(moduleType: .doctor,
                                   searchWords: keyWordObser.value,
                                   pageSize: pageModel.pageSize,
                                   pageNum: pageModel.currentPage))
            .map(model: HCDoctorListModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            }) { [weak self] in
                self?.revertCurrentPageAndRefreshStatus()
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}

class HCArticleSearchViewModel: RefreshVM<HCRealTimeListItemModel> {
    
    public let keyWordObser = Variable("")

    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.search(moduleType: .article,
                                   searchWords: keyWordObser.value,
                                   pageSize: pageModel.pageSize,
                                   pageNum: pageModel.currentPage))
            .map(model: HCRealTimeListModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            }) { [weak self] in
                self?.revertCurrentPageAndRefreshStatus()
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}

class HCCourseSearchViewModel: RefreshVM<HCCourseListItemModel> {
    
    public let keyWordObser = Variable("")

    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.search(moduleType: .course,
                                   searchWords: keyWordObser.value,
                                   pageSize: pageModel.pageSize,
                                   pageNum: pageModel.currentPage))
            .map(model: HCCourseListModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            }) { [weak self] in
                self?.revertCurrentPageAndRefreshStatus()
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}

class HCLiveSearchViewModel: RefreshVM<HCLiveVideoListItemModel> {
    
    public let keyWordObser = Variable("")

    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.search(moduleType: .live,
                                   searchWords: keyWordObser.value,
                                   pageSize: pageModel.pageSize,
                                   pageNum: pageModel.currentPage))
            .map(model: HCLiveVideoListModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            }) { [weak self] in
                self?.revertCurrentPageAndRefreshStatus()
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}
