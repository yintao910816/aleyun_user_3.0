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
    
    public let listItemSignal = Variable([[HCListCellItem]]())
    public let clearCacheSignal = PublishSubject<Void>()

    override init() {
        super.init()
        
        clearCacheSignal
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                ImageCacheCenter.shared.clear {
                    let tempD = strongSelf.listItemSignal.value
                    tempD[0][2].detailTitle = "0M"
                    self?.listItemSignal.value = tempD
                    self?.hud.successHidden("清除成功")
                }
            })
            .disposed(by: disposeBag)
        
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
        let subTitles: [String] = ["", "", "0M", "", "", ""]
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
        
        listItemSignal.value = [items, [loginOutItem]]
        
        ImageCacheCenter.shared.size { [weak self] size in
            items[2].detailTitle = size
            self?.listItemSignal.value = [items, [loginOutItem]]
        }
    }
}
