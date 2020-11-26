//
//  HCTestTubeViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/26.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCTestTubeViewModel: BaseViewModel {
    
    public let datasource = Variable([HCGroupCmsArticleModel]())
    public let articleDetailSignal = PublishSubject<HCCmsArticleListModel>()

    override init() {
        super.init()

        articleDetailSignal
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in self.requestArticleDetail(data: $0) })
            .disposed(by: disposeBag)

        reloadSubject
            .subscribe(onNext: { [weak self] in self?.requestGroupCmsArticle() })
            .disposed(by: disposeBag)
    }
    
    private func requestGroupCmsArticle() {
        hud.noticeLoading()
        HCProvider.request(.groupCmsArticle(code: .SGBK))
            .map(models: HCGroupCmsArticleModel.self, transformKey: "name", transformModelKey: "articleVoList")
            .subscribe(onSuccess: { [weak self] data in
                var sortedModels: [HCGroupCmsArticleModel] = []
                sortedModels.append(data.first(where: { $0.name == "检查准备" }) ?? HCGroupCmsArticleModel.createEmpty(name: "检查准备"))
                sortedModels.append(data.first(where: { $0.name == "定方案" }) ?? HCGroupCmsArticleModel.createEmpty(name: "定方案"))
                sortedModels.append(data.first(where: { $0.name == "促排" }) ?? HCGroupCmsArticleModel.createEmpty(name: "促排"))
                sortedModels.append(data.first(where: { $0.name == "取卵取精" }) ?? HCGroupCmsArticleModel.createEmpty(name: "取卵取精"))
                sortedModels.append(data.first(where: { $0.name == "胚胎培养" }) ?? HCGroupCmsArticleModel.createEmpty(name: "胚胎培养"))
                sortedModels.append(data.first(where: { $0.name == "验孕保胎" }) ?? HCGroupCmsArticleModel.createEmpty(name: "验孕保胎"))
                sortedModels.append(data.first(where: { $0.name == "怀孕难题" }) ?? HCGroupCmsArticleModel.createEmpty(name: "怀孕难题"))

                self?.datasource.value = sortedModels
                self?.hud.noticeHidden()
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
        
    }
    
    private func requestArticleDetail(data: HCCmsArticleListModel) {
        HCProvider.request(.cmsDetail(articleId: data.id))
            .map(model: HCCmsDetailModel.self)
            .subscribe { [weak self] linkM in
                HCHomeViewModel.push(BaseWebViewController.self, ["url": linkM.hrefUrl, "title": linkM.title])
                self?.hud.noticeHidden()
            } onError: { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}
