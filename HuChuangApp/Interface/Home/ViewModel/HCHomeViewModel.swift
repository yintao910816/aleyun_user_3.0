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
    
    private var allArticleDatas: [String: [HCCmsArticleModel]] = [:]
    
    public let functionsMenuSignal = Variable(([HCFunctionsMenuModel](), [HCCmsCmsChanelListModel]()))
    public let articleDataSignal = Variable([HCCmsArticleModel]())
    public let articleTypeChangeSignal = PublishSubject<HCMenuItemModel>()
    
    override init() {
        super.init()
        
        articleTypeChangeSignal
            .subscribe(onNext: { [unowned self] in
                if self.allArticleDatas.keys.contains($0.itemId) || $0.itemId == "0" {
                    self.articleDataSignal.value = self.allArticleDatas[$0.itemId] ?? []
                }else {
                    self.requestCmsArticleList(channelId: $0.itemId)
                }
            })
            .disposed(by: disposeBag)
        
        reloadSubject.subscribe(onNext: { [weak self] in self?.requestHeaderDatas() })
            .disposed(by: disposeBag)
    }
    
}

extension HCHomeViewModel {
    
    private func requestHeaderDatas() {
        hud.noticeLoading()
        Observable.combineLatest(requestMenuItems(), requestCmsChanelList()) { ($0, $1) }
            .concatMap({ [unowned self] data -> Observable<[HCCmsArticleModel]> in
                var tempArr: [HCCmsCmsChanelListModel] = []
                let recommendItem = HCCmsCmsChanelListModel()
                recommendItem.id = "0"
                recommendItem.name = "推荐"
                tempArr.append(recommendItem)
                tempArr.append(contentsOf: data.1)
                
                self.functionsMenuSignal.value = (data.0, tempArr)
                return self.requestRecomCms()
            })
            .subscribe(onNext: { [unowned self] data in
                self.allArticleDatas["0"] = data
                self.articleDataSignal.value = data
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
 
    // 推荐栏目文章
    private func requestRecomCms() ->Observable<[HCCmsArticleModel]> {
        return HCProvider.request(.cmsRecommend(cmsCode: .SGBK))
            .map(models: HCCmsArticleModel.self)
            .asObservable()
            .catchErrorJustReturn([HCCmsArticleModel]())
    }
    
    /// 栏目
    private func requestCmsChanelList() ->Observable<[HCCmsCmsChanelListModel]> {
        return HCProvider.request(.cmsCmsChanelList(cmsCode: .RMZX))
            .map(models: HCCmsCmsChanelListModel.self)
            .asObservable()
            .catchErrorJustReturn([HCCmsCmsChanelListModel]())
    }
    
    /// 栏目文章
    private func requestCmsArticleList(channelId: String) {
        HCProvider.request(.cmsArticleList(channelId: channelId))
            .map(models: HCCmsArticleModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.allArticleDatas[channelId] = $0
                self?.articleDataSignal.value = $0
            })
            .disposed(by: disposeBag)
    }
}
