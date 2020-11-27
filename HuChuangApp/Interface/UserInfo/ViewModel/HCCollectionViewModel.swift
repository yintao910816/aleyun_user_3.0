//
//  HCCollectionViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/21.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCCollectionDoctorViewModel: RefreshVM<HCDoctorListItemModel> {
    
    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.attentionStore(moduleType: .doctor, pageNum: pageModel.currentPage, pageSize: pageModel.pageSize))
            .map(model: HCCollectionDoctorData.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            }) { [weak self] _ in
                self?.revertCurrentPageAndRefreshStatus()
            }
            .disposed(by: disposeBag)
    }

}

class HCCollectionCourseViewModel: RefreshVM<HCCollectionCourseModel> {
    
    override init() {
        super.init()
    }

    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.attentionStore(moduleType: .course, pageNum: pageModel.currentPage, pageSize: pageModel.pageSize))
            .map(model: HCCollectionCourseData.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            }) { [weak self] _ in
                self?.revertCurrentPageAndRefreshStatus()
            }
            .disposed(by: disposeBag)
    }
}

class HCCollectionInformationViewModel: RefreshVM<HCCmsArticleListModel> {

    public let articleDetailSignal = PublishSubject<HCCmsArticleListModel>()

    override init() {
        super.init()
        
        articleDetailSignal
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in self.requestArticleDetail(data: $0) })
            .disposed(by: disposeBag)
    }

    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.attentionStore(moduleType: .information, pageNum: pageModel.currentPage, pageSize: pageModel.pageSize))
            .map(model: HCCollectionInformationData.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0.records, $0.pages)
            }) { [weak self] _ in
                self?.revertCurrentPageAndRefreshStatus()
            }
            .disposed(by: disposeBag)
    }
    
    private func requestArticleDetail(data: HCCmsArticleListModel) {
        HCProvider.request(.cmsDetail(articleId: data.id))
            .map(model: HCCmsDetailModel.self)
            .subscribe { [weak self] linkM in
                let params = HCShareWebViewController.configParameters(mode: .article, model: HCShareDataModel.transformCmsModel(model: linkM))
                HCHomeViewModel.push(HCShareWebViewController.self, params)
                self?.hud.noticeHidden()
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}
