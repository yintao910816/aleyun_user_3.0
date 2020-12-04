//
//  HCToolViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCToolViewModel: BaseViewModel {
        
    public let listItemSubject = PublishSubject<[HCListCellItem]>()
    
    override init() {
        super.init()
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.prepareCellItems()
            })
            .disposed(by: disposeBag)
    }
    
}

extension HCToolViewModel {
    
    private func prepareCellItems() {
        var items: [HCListCellItem] = []
        
        let titles: [String] = ["大姨妈来了", "爱爱", "体温", "体重", "经期设置"]
        let titleIconss: [String] = ["tool_dayima", "tool_aiai", "tool_tiwen", "tool_weight", "tool_setting"]
        let identifiers: [String] = [HCListSwitchCell_identifier, HCListSwitchCell_identifier, HCListDetailNewTypeCell_identifier, HCListDetailNewTypeCell_identifier, HCListDetailNewTypeCell_identifier]
        for idx in 0..<titles.count {
            let item = HCListCellItem()
            item.cellHeight = 55
            item.titleIcon = titleIconss[idx]
            item.title = titles[idx]
            item.titleFont = .font(fontSize: 18)
            item.titleColor = RGB(51, 51, 51)
            item.cellIdentifier = identifiers[idx]
            item.bottomLineMode = .title
            items.append(item)
        }
        
        listItemSubject.onNext(items)
    }
}
