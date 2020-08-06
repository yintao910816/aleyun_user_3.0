//
//  HCMenstruationHistoryViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/11/26.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class HCMenstruationHistoryViewModel: BaseViewModel {
    
    private var dataModel: HCHealthArchivesModel!
    // 月经史数据
    private var menstruationHistoryDatas: [HCListCellItem] = []
    // 婚育史数据
    private var maritalHistoryDatas: [HCListCellItem] = []
    private var page: Int = 0

    public var datasourceObser = Variable([HCListCellItem]())

    init(dataModel: HCHealthArchivesModel,
         tap: (menstruationHistoryTap: Driver<Void>, maritalHistoryTap: Driver<Void>)) {
        super.init()
        
        self.dataModel = dataModel
        
        tap.menstruationHistoryTap
            .drive(onNext: { [unowned self] in
                self.datasourceObser.value = self.menstruationHistoryDatas
            })
            .disposed(by: disposeBag)
        
        tap.maritalHistoryTap
            .drive(onNext: { [unowned self] in
                self.datasourceObser.value = self.maritalHistoryDatas
            })
            .disposed(by: disposeBag)

        dealData()
    }
    
    private func dealData() {
        var titles = ["第一次来月经(岁)＊", "最近一次月经来潮时间＊", "月经量＊", "是否痛经＊", "月经天数＊", "月经周期＊"]
        var realDatas = [dataModel.menstruationHistory.catMenarche,
                         dataModel.menstruationHistory.catLastCatamenia,
                         dataModel.menstruationHistory.catCatameniaAmount,
                         dataModel.menstruationHistory.catDysmenorrhea,
                         dataModel.menstruationHistory.catMensescycleDay,
                         dataModel.menstruationHistory.catMensescycle]
        for idx in 0..<titles.count {
            let title = titles[idx]
            var model = HCListCellItem()
            model.attrbuiteTitle = title.attributed([NSMakeRange(0, title.count - 1), NSMakeRange(title.count - 1, 1)],
                                                    color: [RGB(102, 102, 102), HC_MAIN_COLOR])
            model.detailTitle = realDatas[idx]
            model.inputEnable = false
            menstruationHistoryDatas.append(model)
        }
        
        titles = ["婚姻情况＊", "初/再婚几年＊", "未避孕未孕(年)＊", "是否有过怀孕＊", "人工流产＊", "宫外孕＊"]
        realDatas = [dataModel.maritalHistory.marReMarriage,
                     dataModel.maritalHistory.marReMarriageAge,
                     dataModel.maritalHistory.contraceptionNoPregnancyNo,
                     dataModel.maritalHistory.isPregnancy,
                     dataModel.maritalHistory.marDrugAbortion,
                     dataModel.maritalHistory.ectopicPregnancy]
        for idx in 0..<titles.count {
            let title = titles[idx]
            var model = HCListCellItem()
            model.attrbuiteTitle = title.attributed([NSMakeRange(0, title.count - 1), NSMakeRange(title.count - 1, 1)],
                                                    color: [RGB(102, 102, 102), HC_MAIN_COLOR])
            model.detailTitle = realDatas[idx]
            model.inputEnable = false
            maritalHistoryDatas.append(model)
        }

        datasourceObser.value = menstruationHistoryDatas
    }
}
