//
//  HCDoctorInfoViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/4.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCDoctorInfoViewModel: BaseViewModel {
    
    private var userId: String = ""
    
    public let reloadUI = PublishSubject<HCDoctorInfoModel>()
    
    init(userId: String) {
        super.init()
        
        self.userId = userId
        
        reloadSubject.asObserver()
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [unowned self] in
                self.requestData()
            })
            .disposed(by: disposeBag)
    }
    
    private func requestData() {
        HCProvider.request(.getUserInfo(userId: userId))
            .map(model: HCDoctorInfoModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.hud.noticeHidden()
                self?.reloadUI.onNext(data)
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
        }
        .disposed(by: disposeBag)
    }
}
