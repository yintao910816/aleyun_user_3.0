//
//  HCVerifyViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/15.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCVerifyViewModel: BaseViewModel {
    
    private var mobile: String = ""
    
    private var timer: CountdownTimer!
    
    public let codeSignal = PublishSubject<String>()
    public let beginTimer = PublishSubject<Void>()
    public let popLoginSubject = PublishSubject<Void>()
    public let remindSectionSignal = Variable("")
    
    init(mobile: String) {
        super.init()
        
        self.mobile = mobile
        
        timer = CountdownTimer.init(timeInterval: 1, totleCount: 60)
        
        timer.showText.asDriver()
            .drive(onNext: { [weak self] in
                if $0 == 0 {
                    self?.popLoginSubject.onNext(Void())
                }else {
                    self?.remindSectionSignal.value = "\($0)S后重新发送"
                }
            })
            .disposed(by: disposeBag)
        
        beginTimer.subscribe(onNext: { [weak self] in self?.timer.timerStar()})
            .disposed(by: disposeBag)
        
        codeSignal
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] in self?.requestLogin(code: $0)})
            .disposed(by: disposeBag)
    }
    
}

extension HCVerifyViewModel {
    
    private func requestLogin(code: String) {
        HCProvider.request(.loginTel(mobile: mobile, smsCode: code))
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
