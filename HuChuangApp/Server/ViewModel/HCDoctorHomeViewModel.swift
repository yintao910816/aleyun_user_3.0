//
//  HCDoctorHomeModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/30.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HCDoctorHomeViewModel: BaseViewModel {
    
    private var doctorModel: HCDoctorItemModel!

    init(doctorModel: HCDoctorItemModel, shareDriver: Driver<Void>) {
        super.init()
        
        self.doctorModel = doctorModel
        
        shareDriver
            .drive(onNext: { [unowned self] in
                let shareLink = HCAccountManager.doctorHomeLink(forShare: self.doctorModel.userId)
                HCAccountManager.presentShare(thumbURL: self.doctorModel.headPath,
                                              title: "医生主页",
                                              descr: self.doctorModel.titleText,
                                              webpageUrl: shareLink)
            })
            .disposed(by: disposeBag)
    }

}
