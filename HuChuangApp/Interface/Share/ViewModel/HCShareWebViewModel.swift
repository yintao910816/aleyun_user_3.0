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
import Moya

class HCShareWebViewModel: BaseViewModel {
    
    private var shareModel: HCShareDataModel!
    private var mode: HCShareMode!
    
    public let articleStatusObser = Variable(HCStoreAndStatusModel())
    public let storeEnable = Variable(false)

    init(input:(shareModel: HCShareDataModel, mode: HCShareMode),
         tap:(storeDriver: Driver<Bool>, shareDriver: Driver<Void>)) {
        super.init()

        shareModel = input.shareModel
        mode = input.mode
        
        reloadSubject
            .subscribe(onNext: { [weak self] _ in
                self?.requestStatus()
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
                let link = APIAssistance.shareLink(forUrl: self.shareModel.link)
                HCAccountManager.presentShare(thumbURL: self.shareModel.picPath,
                                              title: "您的孕期好帮手",
                                              descr: self.shareModel.title,
                                              webpageUrl: link)
            })
            .disposed(by: disposeBag)
    }
    
}

extension HCShareWebViewModel {
    
    // 文章收藏状态
    private func requestStatus() {
        var signal: Single<Response>!
        switch mode {
        case .article:
            signal = HCProvider.request(.cmsFollow(articleId: shareModel.id))
        case .doctor:
            signal = HCProvider.request(.doctorFollow(userId: shareModel.userId, memberId: shareModel.memberId))
        case .none:
            break
        }
        signal.mapJSON()
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
    }
    
    // 收藏点击
    private func postChangeStatus(status: Bool) {
        var signal: Single<Response>!
        switch mode {
        case .article:
            signal = HCProvider.request(.articelStore(articleId: shareModel.id, storeStatus: status))
        case .doctor:
            signal = HCProvider.request(.attentionDoctor(userId: shareModel.userId, attention: status))
        case .none:
            break
        }

        signal.mapResponse()
            .subscribe(onSuccess: { [weak self] data in
                guard let strongSelf = self else { return }
                if data.code == RequestCode.success.rawValue {
                    let statusModel = strongSelf.articleStatusObser.value
                    statusModel.store = status ? statusModel.store + 1 : statusModel.store - 1
                    statusModel.status = status
                    
                    strongSelf.articleStatusObser.value = statusModel
                    
                    let message: String = status == true ? "收藏成功" : "取消收藏"
                    strongSelf.hud.successHidden(message)
                    
                    if strongSelf.mode == .article {
                        NotificationCenter.default.post(name: NotificationName.APPAction.articleStoreSuccess, object: nil)
                    }
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
