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

class HCSearchViewModel: RefreshVM<HCBaseSearchItemModel> {
        
    private var menuPageListData: [HCsearchModule: [HCBaseSearchItemModel]] = [:]
    // 记录当前第几页数据
    private var module: HCsearchModule = .all

    public let keyWordObser = Variable("")
//    public let pageListData = PublishSubject<([HCBaseSearchItemModel], HCsearchModule)>()
    /// 全部-医生-课程-文章
    public let pageListData = PublishSubject<([HCSearchDataModel], [HCSearchDoctorItemModel], [HCSearchCourseItemModel], [HCSearchArticleItemModel], HCsearchModule)>()

    public let requestSearchListSubject = PublishSubject<HCsearchModule>()
    /// 绑定当前滑动到哪个栏目
    public let currentPageObser = Variable(HCsearchModule.all)
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
        
//        requestSearchListSubject
//            .subscribe(onNext: { [unowned self] module in
//                self.module = module
//                if let list = self.menuPageListData[module] {
//                    self.pageListData.onNext((list, module))
//                }else {
//                    self.requestData(true)
//                }
//            })
//            .disposed(by: disposeBag)
        
        requestSearchSubject
            .subscribe(onNext: { [unowned self] cache in
                if cache { self.cacheSearchRecord() }
                self.module = .all
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
        
        HCProvider.request(.search(pageNum: currentPage(for: module.rawValue),
                                   pageSize: pageSize(for: module.rawValue),
                                   searchModule: module,
                                   searchName: keyWordObser.value))
            .map(model: HCSearchDataModel.self)
            .subscribe(onSuccess: { [weak self] in self?.dealSuccess(data: $0, refresh: refresh) },
                       onError: { [weak self] in self?.dealFailure(error: $0) })
            .disposed(by: disposeBag)

        
//        updatePage(for: module.rawValue, refresh: refresh)
//
//        let requestProvider = HCProvider.request(.search(pageNum: currentPage(for: module.rawValue),
//                                                         pageSize: pageSize(for: module.rawValue),
//                                                         searchModule: module,
//                                                         searchName: keyWordObser.value))
//
//        switch module {
//        case .all:
//            requestProvider
//                .map(model: HCSearchDataModel.self)
//                .subscribe(onSuccess: { [weak self] in self?.dealSuccess(data: $0, refresh: refresh) },
//                           onError: { [weak self] in self?.dealFailure(error: $0) })
//                .disposed(by: disposeBag)
//        case .article:
//            requestProvider
//                .map(model: HCSearchArticleModel.self)
//                .subscribe(onSuccess: { [weak self] in self?.dealSuccess(data: $0, refresh: refresh) },
//                           onError: { [weak self] in self?.dealFailure(error: $0) })
//                .disposed(by: disposeBag)
//        case .course:
//            requestProvider
//                .map(model: HCSearchCourseModel.self)
//                .subscribe(onSuccess: { [weak self] in self?.dealSuccess(data: $0, refresh: refresh) },
//                           onError: { [weak self] in self?.dealFailure(error: $0) })
//                .disposed(by: disposeBag)
//        case .doctor:
//            requestProvider
//                .map(model: HCSearchDoctorModel.self)
//                .subscribe(onSuccess: { [weak self] in self?.dealSuccess(data: $0, refresh: refresh) },
//                           onError: { [weak self] in self?.dealFailure(error: $0) })
//                .disposed(by: disposeBag)
//        }
    }

}

extension HCSearchViewModel {
    
    private func dealSuccess(data: HCBaseSearchItemModel, refresh: Bool) {
        if menuPageListData[module] == nil {
            menuPageListData[module] = [HCBaseSearchItemModel]()
        }
        
        var datas = [HCBaseSearchItemModel]()
        switch module {
        case .all:
            if menuPageListData[HCsearchModule.doctor] == nil {
                menuPageListData[HCsearchModule.doctor] = [HCBaseSearchItemModel]()
            }
            if menuPageListData[HCsearchModule.course] == nil {
                menuPageListData[HCsearchModule.course] = [HCBaseSearchItemModel]()
            }
            if menuPageListData[HCsearchModule.article] == nil {
                menuPageListData[HCsearchModule.article] = [HCBaseSearchItemModel]()
            }

            datas = [data]
            
            let searchData = data as! HCSearchDataModel
            
            updateRefresh(refresh: true,
                          models: searchData.doctor,
                          dataModels: &(menuPageListData[.doctor])!,
                          pages: 10,
                          pageKey: HCsearchModule.doctor.rawValue)

            updateRefresh(refresh: true,
                          models: searchData.course,
                          dataModels: &(menuPageListData[.course])!,
                          pages: 10,
                          pageKey: HCsearchModule.course.rawValue)

            updateRefresh(refresh: true,
                          models: searchData.article,
                          dataModels: &(menuPageListData[.article])!,
                          pages: 10,
                          pageKey: HCsearchModule.article.rawValue)
        case .article:
            datas = (data as? HCSearchArticleModel)?.records ?? [HCBaseSearchItemModel]()
        case .doctor:
            datas = (data as? HCSearchDoctorModel)?.records ?? [HCBaseSearchItemModel]()
        case .course:
            datas = (data as? HCSearchCourseModel)?.records ?? [HCBaseSearchItemModel]()
            break
        }
        
        updateRefresh(refresh: refresh,
                      models: datas,
                      dataModels: &(menuPageListData[module])!,
                      pages: data.pages,
                      pageKey: module.rawValue)
                
        let allData = HCSearchDataModel.init()
        if let allSource = menuPageListData[.all]?.first as? HCSearchDataModel {
            allData.doctor = allSource.doctor.count > 3 ? Array(allSource.doctor[0...2]) : allSource.doctor
            allData.course = allSource.course.count > 3 ? Array(allSource.course[0...2]) : allSource.course
            allData.article = allSource.article.count > 3 ? Array(allSource.article[0...2]) : allSource.article
        }
        
        var doctorData = [HCSearchDoctorItemModel]()
        if let dotorSource = menuPageListData[.doctor] as? [HCSearchDoctorItemModel] {
            doctorData = dotorSource
        }
        
        var courseData = [HCSearchCourseItemModel]()
        if let courseSource = menuPageListData[.course] as? [HCSearchCourseItemModel] {
            courseData = courseSource
        }

        var articleData = [HCSearchArticleItemModel]()
        if let articleSource = menuPageListData[.article] as? [HCSearchArticleItemModel] {
            articleData = articleSource
        }

        pageListData.onNext(([allData], doctorData, courseData, articleData, module))
        
        if keyWordObser.value.count > 0 {
            hud.noticeHidden()
        }
    }
    
    private func dealFailure(error: Error) {
        if keyWordObser.value.count > 0 {
            hud.failureHidden(errorMessage(error))
        }else {
            revertCurrentPageAndRefreshStatus(pageKey: module.rawValue)
        }
    }
    
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
