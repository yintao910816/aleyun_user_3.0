//
//  HCAskViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/24.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCAskViewModel: BaseViewModel {
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

class HCAskPicModel {
    var isAdd: Bool = false
    var image: UIImage?
    
    public class func creatAddItem() ->HCAskPicModel {
        let model = HCAskPicModel()
        model.isAdd = true
        model.image = UIImage.init(named: "consult_ask_add")
        return model
    }
}
