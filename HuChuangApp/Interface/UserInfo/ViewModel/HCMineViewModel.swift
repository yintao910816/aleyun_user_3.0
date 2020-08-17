//
//  HCMineViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class HCMineViewModel: BaseViewModel {
    
    public let personalCenterInfoSignal = Variable(HCPersonalCenterInfoModel())
    public let userInfoSignal = Variable(HCUserModel())

    override init() {
        super.init()
        
        HCHelper.share.userInfoHasReload
            .subscribe(onNext: { [weak self] in self?.userInfoSignal.value = $0 })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.userInfoSignal.value = HCHelper.share.userInfoModel ?? HCUserModel()
                self?.requestPersonalCenterInfo()
            })
            .disposed(by: disposeBag)
    }
}

extension HCMineViewModel {
    
    private func requestPersonalCenterInfo() {
        HCProvider.request(.personalCenterInfo)
            .map(model: HCPersonalCenterInfoModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.personalCenterInfoSignal.value = $0
            })
            .disposed(by: disposeBag)
    }
}
