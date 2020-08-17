//
//  HCLoginViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/7.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class HCLoginViewModel: BaseViewModel, VMNavigation {
    
    public var enableCode: Driver<Bool>!
    
    init(input: Driver<String>, tap:(codeTap: Driver<Void>, agreeTap: Driver<Bool>)) {
        super.init()
        
        enableCode = Driver.combineLatest(input, tap.agreeTap){ ($0, $1) }
            .map({ ret -> Bool in
                if !ret.1 {
                    return false
                }
                
                if !ValidateNum.phoneNum(ret.0).isRight {
                    return false
                }
                
                return true
            })
            .asDriver()
        
        tap.codeTap.withLatestFrom(input)
            ._doNext(forNotice: hud)
            .drive(onNext: { [weak self] in self?.requestCode(mobile: $0) })
            .disposed(by: disposeBag)
    }
}

extension HCLoginViewModel {
    
    private func requestCode(mobile: String) {
        #if DEBUG
        hud.noticeHidden()
        HCLoginViewModel.push(HCVerifyViewController.self, ["mobile": mobile])
        #else
        HCProvider.request(.validateCode(mobile: mobile))
            .mapResponse()
            .subscribe(onSuccess: { [weak self] res in
                if RequestCode(rawValue: res.code) == .success {
                    self?.hud.noticeHidden()
                    HCLoginViewModel.push(HCVerifyViewController.self, ["mobile": mobile])
                }else {
                    self?.hud.failureHidden(res.message)
                }
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
        #endif
    }

}
