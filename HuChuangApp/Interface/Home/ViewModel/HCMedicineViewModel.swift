//
//  HCMedicineViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/27.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

class HCMedicineViewModel: RefreshVM<HCMedicineItemModel> {
    
    private var searchWords: String = ""
    
    override init() {
        super.init()
        
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.medicine(searchWords: searchWords))
            .map(models: HCMedicineItemModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0, 1)
            })
            .disposed(by: disposeBag)
    }
}
