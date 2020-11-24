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
                self?.datasource.value = data
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
