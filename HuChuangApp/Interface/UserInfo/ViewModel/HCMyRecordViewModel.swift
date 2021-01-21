//
//  HCMyRecordViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/8/23.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCMyPicRecordViewModel: RefreshVM<HCConsultItemModel> {
    
    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.myConsult(consultType: 1, pageSize: 10, pageNum: 1, status: "\(HCOrderDetailStatus.finished.rawValue)"))
            .map(result: HCMyRecordItemModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.updateRefresh(refresh, data.data?.records, data.data?.pages ?? 1)
            }) { [weak self] _ in
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
}

class HCMyVideoRecordViewModel: RefreshVM<HCConsultItemModel> {
    
    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.myConsult(consultType: 2, pageSize: 10, pageNum: 1, status: "\(HCOrderDetailStatus.finished.rawValue)"))
            .map(result: HCMyRecordItemModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.updateRefresh(refresh, data.data?.records, data.data?.pages ?? 1)
            }) { [weak self] _ in
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
}

class HCAccurateReservationRecordViewModel: RefreshVM<HCConsultItemModel> {
    
    override init() {
        super.init()
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.myConsult(consultType: 4, pageSize: 10, pageNum: 1, status: "\(HCOrderDetailStatus.finished.rawValue)"))
            .map(result: HCMyRecordItemModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.updateRefresh(refresh, data.data?.records, data.data?.pages ?? 1)
            }) { [weak self] _ in
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)

    }

}
