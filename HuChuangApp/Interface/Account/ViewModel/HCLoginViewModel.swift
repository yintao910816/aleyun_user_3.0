//
//  HCLoginViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/7.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class HCLoginViewModel: BaseViewModel, VMNavigation {
    
    init(input: Driver<String>, tap:(codeTap: Driver<Void>, agreeTap: Driver<Bool>)) {
        super.init()
        
        tap.codeTap
            .drive(onNext: { _ in
                HCLoginViewModel.push(HCVerifyViewController.self, nil)
            })
            .disposed(by: disposeBag)
    }
}
