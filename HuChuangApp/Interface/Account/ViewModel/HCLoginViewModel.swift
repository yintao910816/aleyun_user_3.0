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
    
    init(input: Driver<String>,
         tap:(codeTap: Driver<Void>,
              agreeTap: Driver<Bool>,
              weChatTap: Driver<Void>)) {
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
        
        tap.weChatTap.asObservable()
            ._doNext(forNotice: hud)
            .flatMap{ HCAccountManager.WeChatLogin() }
            .do(onNext: { [weak self] UserInfoRes in
                if let _ = UserInfoRes {
                    self?.hud.noticeHidden()
                }else {
                    self?.hud.failureHidden("未获取到授权信息")
                }
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(self?.errorMessage(error))
            })
            .filter{ $0 != nil }
            .map { $0! }
            .flatMap { [unowned self] in self.getAuthMemberInfoRequest(socialInfo: $0) }
            .subscribe(onNext: { [weak self] data in
                if data.0.code == RequestCode.unBindPhone.rawValue {
                    if let openId = data.1.openid, openId.count > 0 {
                        self?.hud.noticeHidden()
                        HCLoginViewModel.push(HCBindPhoneController.self, ["openId":data.1.openid ?? ""])
                    }else {
                        self?.hud.failureHidden("openId为空")
                    }
                }else if let user = data.0.data{
                    self?.hud.noticeHidden()
                    HCHelper.saveLogin(user: user)
                    self?.popSubject.onNext(Void())
                }else {
                    self?.hud.failureHidden("未获取到用户信息")
                }
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)

    }
}

extension HCLoginViewModel {
    
    private func requestCode(mobile: String) {
//        #if DEBUG
//        hud.noticeHidden()
//        HCLoginViewModel.push(HCVerifyViewController.self, ["mobile": mobile])
//        #else
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
//        #endif
    }

    private func getAuthMemberInfoRequest(socialInfo: UMSocialUserInfoResponse) ->Observable<(DataModel<HCUserModel>,UMSocialUserInfoResponse)>
    {
        return HCProvider.request(.getAuthMember(openId: socialInfo.openid))
            .map(result: HCUserModel.self)
            .map { ($0, socialInfo) }
            .asObservable()
    }

}
