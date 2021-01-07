//
//  HCReservationViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCRegisterReservationViewModel: RefreshVM<HCReservationItemModel> {
    
    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
    }

}

class HCAccurateReservationViewModel: RefreshVM<HCAccurateConsultItemModel> {
    
    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.myConsult(consultType: 4, pageSize: 10, pageNum: 1, status: nil))
            .map(model: HCAccurateConsultModel.self)
            .subscribe(onSuccess: { [weak self] data in                
                self?.updateRefresh(refresh, data.records, data.pages)
            }) { [weak self] in
                self?.revertCurrentPageAndRefreshStatus()
                self?.hud.failureHidden(self?.errorMessage($0))
            }
            .disposed(by: disposeBag)
    }

}
