//
//  HCMenstruationSettingViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/14.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCMenstruationSettingViewModel: BaseViewModel {
    
    private var sectionDatas: [HCMenstruationSettingSection] = []
    
    override init() {
        super.init()
        
        prepareDatas()
    }
    
    public func getSectionDatas() ->[HCMenstruationSettingSection] {
        return sectionDatas
    }
}

extension HCMenstruationSettingViewModel {
    
    private func prepareDatas() {
        let sectionTitles = ["您的月经大概持续几天", "两次月经开始大概间隔多久", "建议开启只能预测"]
        let rowTitles = ["经期长度", "周期长度", "使用智能预测"]
        let identifier = [HCListDetailInputCell_identifier, HCListDetailInputCell_identifier, HCListSwitchCell_identifier]

        for idx in 0..<sectionTitles.count {
            var rowItem = HCListCellItem()
            rowItem.title = rowTitles[idx]
            rowItem.cellIdentifier = identifier[idx]
            rowItem.shwoArrow = false
                    
            sectionDatas.append(HCMenstruationSettingSection.init(sectinoTitle: sectionTitles[idx], itemDatas: [rowItem]))
        }
    }
}
