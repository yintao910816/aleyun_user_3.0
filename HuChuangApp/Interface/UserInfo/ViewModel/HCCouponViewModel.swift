//
//  HCCouponViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/21.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCCouponViewModel: RefreshVM<HCCouponModel> {
    
    private var useStatus: Int = 1
    public let useStatusChangeSignal = PublishSubject<Bool>()
    
    override init() {
        super.init()

        useStatusChangeSignal
            .subscribe(onNext: { [weak self] in
                self?.useStatus = $0 == true ? 1 : 0
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)

        HCProvider.request(.myCoupon(orderSn: "",
                                     useStatus: useStatus,
                                     pageSize: pageModel.pageSize,
                                     pageNum: pageModel.currentPage))
            .map(model: HCCouponListModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.updateRefresh(refresh, data.records, data.pages)
            }) { [weak self] error in
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
}
