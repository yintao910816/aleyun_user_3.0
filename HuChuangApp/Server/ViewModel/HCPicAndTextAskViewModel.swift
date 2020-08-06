//
//  HCPicAndTextAskViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/2.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCPicAndTextAskViewModel: BaseViewModel {
    private var picModels: [HCAskPicModel] = []
    
    public var reloadUISubject = PublishSubject<Void>()
    
    override init() {
        super.init()
        
        picModels.append(HCAskPicModel.creatAddItem())
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.reloadUISubject.onNext(Void())
        })
            .disposed(by: disposeBag)
    }
    
    public func numberOfItems() ->Int {
        return picModels.count
    }
    
    public func modelForItemAt(_ indexPath: IndexPath) ->HCAskPicModel {
        return picModels[indexPath.row]
    }
}
