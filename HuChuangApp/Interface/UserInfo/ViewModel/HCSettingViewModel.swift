//
//  HCSettingViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/19.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation

import RxSwift

class HCSettingViewModel: BaseViewModel {
    
    public let listItemSubject = PublishSubject<[[HCListCellItem]]>()

    override init() {
        super.init()
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                self?.prepareCellItems()
            })
            .disposed(by: disposeBag)
    }
}

extension HCSettingViewModel {
    
    private func prepareCellItems() {
        var items: [HCListCellItem] = []
        
        let titles: [String] = ["账号设置", "消息通知", "清除缓存", "法律声明", "隐私", "鼓励我们，给我们评分"]
        let subTitles: [String] = ["", "", "20M", "", "", ""]
        for idx in 0..<titles.count {
            let item = HCListCellItem()
            item.title = titles[idx]
            item.titleFont = .font(fontSize: 16, fontName: .PingFMedium)
            item.detailTitle = subTitles[idx]
            item.titleColor = RGB(51, 51, 51)
            item.cellIdentifier = HCListDetailCell_identifier
            items.append(item)
        }
        
        let loginOutItem = HCListCellItem()
        loginOutItem.title = "退出登陆"
        loginOutItem.titleColor = RGB(51, 51, 51)
        loginOutItem.cellIdentifier = HCListDetailCell_identifier
        
        listItemSubject.onNext([items, [loginOutItem]])
    }
}
