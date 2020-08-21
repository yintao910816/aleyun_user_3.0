//
//  HCCouponViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/21.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCCouponViewModel: RefreshVM<HCCouponModel> {
    
    private var useStatus: Int = 1
    
    override init() {
        super.init()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak self] in
            self?.datasource.value = [HCCouponModel(), HCCouponModel()]
        }
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)

        HCProvider.request(.myCoupon(orderSn: "",
                                     useStatus: useStatus,
                                     pageSize: pageModel.pageSize,
                                     pageNum: pageModel.currentPage))
            .map(models: HCCouponModel.self)
            .subscribe(onSuccess: { res in
                
            })
            .disposed(by: disposeBag)
    }
}
