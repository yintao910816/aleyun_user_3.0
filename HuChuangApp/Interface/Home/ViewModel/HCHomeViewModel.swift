//
//  HCHomeViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCHomeViewModel: BaseViewModel, VMNavigation {
    
    private var currentChannelId: String = ""
    private var currentPage: Int = 0
    
    private var allArticleDatas: [String: [HCCmsArticleListModel]] = [:]
    
    public let functionsMenuSignal = Variable(([HCFunctionsMenuModel](), [HCCmsCmsChanelListModel](), [HCCmsRecommendModel](), 0))
    public let articleDataSignal = PublishSubject<([HCCmsArticleListModel], Int)>()
    public let articleTypeChangeSignal = PublishSubject<((HCMenuItemModel,Int))>()
    /// 获取文章详情链接
    public let articleDetailSignal = PublishSubject<HCCmsArticleListModel>()
    
    override init() {
        super.init()
        
        articleDetailSignal
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in self.requestArticleDetail(data: $0) })
            .disposed(by: disposeBag)
        
        articleTypeChangeSignal
            .subscribe(onNext: { [unowned self] in
                if self.allArticleDatas.keys.contains($0.0.itemId) || $0.0.itemId == "0" {
                    self.articleDataSignal.onNext((self.allArticleDatas[$0.0.itemId] ?? [], $0.1))
                }else {
                    self.requestCmsArticleList(channelId: $0.0.itemId, page: $0.1)
                }
                self.currentPage = $0.1
                self.currentChannelId = $0.0.itemId
            })
            .disposed(by: disposeBag)
        
        HCHelper.share.userInfoHasReload
            .subscribe(onNext: { [weak self] _ in self?.requestHeaderDatas() })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(NotificationName.APPAction.articleStoreSuccess, object: nil)
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.requestCmsArticleList(channelId: strongSelf.currentChannelId, page: strongSelf.currentPage)
            })
            .disposed(by: disposeBag)
            
        reloadSubject.subscribe(onNext: { [weak self] in self?.requestHeaderDatas() })
            .disposed(by: disposeBag)
    }
    
}

extension HCHomeViewModel {
    
    private func requestHeaderDatas() {
        hud.noticeLoading()
        Observable.combineLatest(requestMenuItems(), requestRecomCms(cmsCode: .webCms001), requestCmsChanelList()) { ($0, $1, $2) }
            .subscribe(onNext: { [unowned self] data in
                self.functionsMenuSignal.value = (data.0, data.2, data.1, 0)
                if data.2.count > 0 {
                    self.currentPage = 0
                    self.currentChannelId = data.2[0].id
                    self.requestCmsArticleList(channelId: data.2[0].id, page: 0)
                }
                self.hud.noticeHidden()
            })
            .disposed(by: disposeBag)
    }
    
    // 功能区
    private func requestMenuItems() ->Observable<[HCFunctionsMenuModel]> {
        return HCProvider.request(.functionsMenu)
            .map(models: HCFunctionsMenuModel.self)
            .asObservable()
            .catchErrorJustReturn([HCFunctionsMenuModel]())
    }
 
    // 第三部分功能菜单
    private func requestRecomCms(cmsCode: HCCmsType) ->Observable<[HCCmsRecommendModel]> {
        return HCProvider.request(.cmsRecommend(cmsCode: cmsCode))
            .map(models: HCCmsRecommendModel.self)
            .asObservable()
            .catchErrorJustReturn([HCCmsRecommendModel]())
    }
    
    /// 栏目
    private func requestCmsChanelList() ->Observable<[HCCmsCmsChanelListModel]> {
        return HCProvider.request(.cmsCmsChanelList(cmsCode: .webCms001))
            .map(models: HCCmsCmsChanelListModel.self)
            .asObservable()
            .catchErrorJustReturn([HCCmsCmsChanelListModel]())
    }
    
    /// 栏目文章
    private func requestCmsArticleList(channelId: String, page: Int) {
        HCProvider.request(.cmsArticleList(channelId: channelId))
            .map(models: HCCmsArticleListModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.allArticleDatas[channelId] = $0
                self?.articleDataSignal.onNext(($0, page))
                self?.hud.noticeHidden()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestArticleDetail(data: HCCmsArticleListModel) {
        HCProvider.request(.cmsDetail(articleId: data.id))
            .map(model: HCCmsDetailModel.self)
            .subscribe { [weak self] linkM in
                guard let strongSelf = self else { return }
                let params = HCShareWebViewController.configParameters(mode: .article, model: HCShareDataModel.transformCmsModel(model: linkM))
                HCHomeViewModel.push(HCShareWebViewController.self, params)
                strongSelf.hud.noticeHidden()
                
                strongSelf.requestCmsArticleList(channelId: strongSelf.currentChannelId, page: strongSelf.currentPage)
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}
