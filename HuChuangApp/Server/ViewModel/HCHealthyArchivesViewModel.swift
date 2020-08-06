//
//  HCHealthyArchivesViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/25.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCHealthyArchivesViewModel: BaseViewModel {
    private var dataModel: HCHealthArchivesModel = HCHealthArchivesModel()
    
    public var datasourceObser = Variable([HCListCellItem]())
    
    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [weak self] _ in
            self?.requestData()
        })
        .disposed(by: disposeBag)
    }
    
    public func prepareData() ->HCHealthArchivesModel {
        return dataModel
    }
    
    private func requestData() {
        if datasourceObser.value.count == 0 {
            var data = [HCListCellItem]()
            let titles = ["姓名＊", "性别＊", "出生日期＊", "手机号＊", "所在城市＊"]
            let enable = [true, true, false, false, false]
            for idx in 0..<titles.count {
                let title = titles[idx]
                var model = HCListCellItem()
                model.attrbuiteTitle = title.attributed([NSMakeRange(0, title.count - 1), NSMakeRange(title.count - 1, 1)],
                                                        color: [RGB(102, 102, 102), HC_MAIN_COLOR])
                model.inputEnable = enable[idx]
                data.append(model)
            }
            datasourceObser.value = data
        }
        
        hud.noticeLoading()
        
        HCProvider.request(.getHealthArchives)
            .map(model: HCHealthArchivesModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.hud.noticeHidden()
                self?.dealData(data: data)
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error), nil)
        }
        .disposed(by: disposeBag)
    }
    
    private func dealData(data: HCHealthArchivesModel) {
        dataModel = data
        let datas = datasourceObser.value
        let realData = [data.memberInfo.realName, data.memberInfo.sexText, data.memberInfo.birthday, data.memberInfo.mobileInfo, data.memberInfo.cityName]
        for idx in 0..<datas.count {
            var model = datas[idx]
            model.detailTitle = realData[idx]
        }
        
        datasourceObser.value = datas
    }
}
