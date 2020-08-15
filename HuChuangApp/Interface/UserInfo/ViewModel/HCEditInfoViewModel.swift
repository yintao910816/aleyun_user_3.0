//
//  HCEditInfoViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

class HCEditInfoViewModel: BaseViewModel {
    
    public let enableSignal = PublishSubject<Bool>()
    
    init(inputSignal: Driver<String>, commitSignal: Driver<Void>) {
        super.init()
        
        inputSignal.map { $0.count > 0 }
            .drive(enableSignal)
            .disposed(by: disposeBag)
        
        commitSignal.withLatestFrom(inputSignal)
            .drive(onNext: { [weak self] in
                PrintLog($0)
            })
            .disposed(by: disposeBag)
    }
}
