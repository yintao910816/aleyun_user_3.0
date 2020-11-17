//
//  HCMedicineViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/27.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCMedicineViewModel: RefreshVM<HCMedicineItemModel> {
    
    private var searchWords: String = ""
    
    public let keyWordsFilterSubject = PublishSubject<String>()

    override init() {
        super.init()
        
        keyWordsFilterSubject
            .subscribe(onNext: { [unowned self] in
                self.searchWords = $0
                self.requestData(true)
            })
            .disposed(by: disposeBag)
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
