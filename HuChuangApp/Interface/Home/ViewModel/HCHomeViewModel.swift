//
//  HCHomeViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCHomeViewModel: BaseViewModel {
    
    private var allArticleDatas: [String: [HCCmsArticleListModel]] = [:]
    private var pageIdxs: [String: Int] = [:]
    
    public let functionsMenuSignal = Variable(([HCFunctionsMenuModel](), [HCCmsCmsChanelListModel](), [HCCmsRecommendModel](), 0))
    public let articleDataSignal = PublishSubject<([HCCmsArticleListModel], Int)>()
    public let articleTypeChangeSignal = PublishSubject<HCMenuItemModel>()

    override init() {
        super.init()
        
        articleTypeChangeSignal
            .subscribe(onNext: { [unowned self] in
                if self.allArticleDatas.keys.contains($0.itemId) || $0.itemId == "0" {
                    self.articleDataSignal.onNext((self.allArticleDatas[$0.itemId] ?? [], 0))
                }else {
                    self.requestCmsArticleList(channelId: $0.itemId, page: self.pageIdxs[$0.itemId] ?? 0)
                }
            })
            .disposed(by: disposeBag)
        
        HCHelper.share.userInfoHasReload
            .subscribe(onNext: { [weak self] _ in self?.requestHeaderDatas() })
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
                for idx in 0..<data.2.count {
                    self.pageIdxs[data.2[idx].id] = idx
                }
                
                self.functionsMenuSignal.value = (data.0, data.2, data.1, 0)
                if data.2.count > 0 {
                    self.requestCmsArticleList(channelId: data.2[0].id, page: 0)
                }
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
        return HCProvider.request(.cmsCmsChanelList(cmsCode: .RMZX))
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
}
