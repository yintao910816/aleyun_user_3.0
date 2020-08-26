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
    
    override init() {
        super.init()

        reloadSubject
            .subscribe(onNext: { [weak self] in self?.requestGroupCmsArticle() })
            .disposed(by: disposeBag)
    }
    
    private func requestGroupCmsArticle() {
        hud.noticeLoading()
        HCProvider.request(.groupCmsArticle(code: .SGBK))
            .map(models: HCGroupCmsArticleModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.datasource.value = data
                self?.hud.noticeHidden()
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
        
    }
}
