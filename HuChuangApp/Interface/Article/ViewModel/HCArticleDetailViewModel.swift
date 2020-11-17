//
//  HCArticleDetailViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/19.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HCArticleDetailViewModel: BaseViewModel {
    
    private var shareModel: HCShareArticleModel!

    public let articleStatusObser = Variable(HCStoreAndStatusModel())
    public let storeEnable = Variable(false)

    init(shareModel: HCShareArticleModel,
         tap:(storeDriver: Driver<Bool>, shareDriver: Driver<Void>)) {
        super.init()

        self.shareModel = shareModel
        
        reloadSubject
            .subscribe(onNext: { [weak self] _ in
                self?.requestArticleStatus()
            })
            .disposed(by: disposeBag)
        
        tap.storeDriver
            ._doNext(forNotice: hud)
            .drive(onNext: { [unowned self] in
                self.storeEnable.value = false
                self.postChangeStatus(status: $0)
            })
            .disposed(by: disposeBag)
        
        tap.shareDriver
            .drive(onNext: { [unowned self] in
                let link = APIAssistance.articleLink(forUrl: self.shareModel.link)
                HCAccountManager.presentShare(thumbURL: self.shareModel.picPath,
                                              title: "您的孕期好帮手",
                                              descr: self.shareModel.title,
                                              webpageUrl: link)
            })
            .disposed(by: disposeBag)
    }
    
    private func requestArticleStatus() {
        HCProvider.request(.cmsFollow(articleId: shareModel.id))
            .mapJSON()
            .asObservable()
            .map({ res -> HCStoreAndStatusModel in
                let staModel = HCStoreAndStatusModel()
                if let dic = res as? [String: Any], let s = dic["data"] as? Bool {
                    staModel.status = s
                }
                return staModel
            })
            .do(onNext: { [weak self] _ in self?.storeEnable.value = true })
            .catchErrorJustReturn(HCStoreAndStatusModel())
            .bind(to: articleStatusObser)
            .disposed(by: disposeBag)

//        HCProvider.request(.storeAndStatus(articleId: shareModel.id))
//            .map(model: HCStoreAndStatusModel.self)
//            .asObservable()
//            .do(onNext: { [weak self] _ in self?.storeEnable.value = true })
//            .catchErrorJustReturn(HCStoreAndStatusModel())
//            .bind(to: articleStatusObser)
//            .disposed(by: disposeBag)
    }
    
    private func postChangeStatus(status: Bool) {
        HCProvider.request(.articelStore(articleId: shareModel.id, storeStatus: status))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] data in
                guard let strongSelf = self else { return }
                if data.code == RequestCode.success.rawValue {
                    let statusModel = strongSelf.articleStatusObser.value
                    statusModel.store = status ? statusModel.store + 1 : statusModel.store - 1
                    statusModel.status = status
                    
                    strongSelf.articleStatusObser.value = statusModel
                    
                    strongSelf.hud.noticeHidden()
                }else {
                    strongSelf.hud.failureHidden(data.message)
                }
                
                strongSelf.storeEnable.value = true
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
                self?.storeEnable.value = true
        }
        .disposed(by: disposeBag)
    }
}
