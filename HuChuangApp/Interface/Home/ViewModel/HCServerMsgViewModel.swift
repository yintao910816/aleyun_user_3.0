//
//  HCServerMsgViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/11/26.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCServerMsgViewModel: RefreshVM<HCMessageItemModel> {
    
    override init() {
        super.init()
        
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.msgListByCode(code: HCMsgListCode.notification_type1, pageNum: 1, pageSize: 10))
            .map(models: HCMessageItemModel.self)
//            .map(result: HCServerMsgModel.self)
            .subscribe(onSuccess: { [weak self] in
//                self?.updateRefresh(refresh, $0.data?.records, $0.data?.total ?? 1)
                self?.updateRefresh(refresh, $0, 1)
                }, onError: { [weak self] _ in
                    self?.revertCurrentPageAndRefreshStatus()
            })
            .disposed(by: disposeBag)
    }
    
}
