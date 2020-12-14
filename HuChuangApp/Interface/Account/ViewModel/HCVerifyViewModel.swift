//
//  HCVerifyViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/15.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCVerifyViewModel: BaseViewModel, VMNavigation {
    
    private var mobile: String = ""
    private var openId: String?

    private var timer: CountdownTimer!
    
    public let codeSignal = PublishSubject<String>()
    public let beginTimer = PublishSubject<Void>()
    public let popLoginSubject = PublishSubject<Void>()
    public let remindSectionSignal = Variable("")
    
    init(mobile: String, openId: String?) {
        super.init()
        
        self.mobile = mobile
        self.openId = openId
        
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
        var signal = HCProvider.request(.loginTel(mobile: mobile, smsCode: code))
        if let _op = openId, _op.count > 0 {
            signal = HCProvider.request(.bindAuthMember(openId: _op, mobile: mobile, smsCode: code))
        }

        signal.map(result: HCUserModel.self)
            .subscribe(onSuccess: { [weak self] in
                if RequestCode(rawValue: $0.code) == .unVerified {
                    if let user = $0.data {
                        self?.hud.noticeHidden()
                        HCHelper.saveLogin(user: user)
                    }
                    self?.timer.timerRemove()
                    HCLoginViewModel.push(HCRealNameAuthorViewController.self, nil)
                }else if RequestCode(rawValue: $0.code) == .success {
                    if let user = $0.data {
                        self?.timer.timerRemove()
                        
                        self?.hud.noticeHidden()
                        self?.popSubject.onNext(Void())
                        HCHelper.saveLogin(user: user)
                        
                        NotificationCenter.default.post(name: NotificationName.User.LoginSuccess, object: nil)
                    }
                }else {
                    self?.hud.failureHidden($0.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }
}
