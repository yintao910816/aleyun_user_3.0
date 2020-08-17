//
//  HCEditInfoViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class HCEditInfoViewModel: BaseViewModel {
    
    public let enableSignal = PublishSubject<Bool>()
    public let contentSignal = PublishSubject<String>()
    
    init(inputSignal: Driver<String>, commitSignal: Driver<Void>) {
        super.init()
        
        inputSignal.map { $0.count > 0 }
            .drive(enableSignal)
            .disposed(by: disposeBag)
        
        commitSignal.withLatestFrom(inputSignal)
            .drive(onNext: { [weak self] in self?.requestUpdateNickName(nickName: $0) })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                let content = HCHelper.share.userInfoModel?.name ?? ""
                self?.contentSignal.onNext(content)
                self?.enableSignal.onNext(content.count > 0)
            })
            .disposed(by: disposeBag)
    }
}

extension HCEditInfoViewModel {
    
    private func requestUpdateNickName(nickName: String) {
        guard let user = HCHelper.share.userInfoModel else {
            hud.failureHidden("用户信息获取失败，请重新登录") {
                HCHelper.presentLogin()
            }
            return
        }

        hud.noticeLoading()
        HCProvider.request(.accountSetting(nickName: nickName, headPath: user.headPath))
            .map(model: HCUserModel.self)
            .subscribe(onSuccess: { [weak self] in
                HCHelper.saveLogin(user: $0)
                self?.hud.noticeHidden()
                self?.popSubject.onNext(Void())
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    
    }
}
