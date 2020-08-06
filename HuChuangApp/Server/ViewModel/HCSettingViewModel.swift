//
//  HCSettingViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/12/6.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class HCSettingViewModel: BaseViewModel {
    var listDataObser = Variable([SectionModel<Int, HCListCellItem>]())
    
    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [weak self] in
            self?.prepareData()
        })
        .disposed(by: disposeBag)
    }
    
    private func prepareData() {
        var datas = [HCListCellItem]()
        
        datas.append(HCListCellItem.init(title: "账号与安全", shwoArrow: true, cellIdentifier: HCBaseListCell_identifier))
//        datas.append(HCListCellItem.init(title: "接受消息通知", shwoArrow: false, cellIdentifier: HCListSwitchCell_identifier))
        datas.append(HCListCellItem.init(title: "清除缓存", shwoArrow: true, cellIdentifier: HCBaseListCell_identifier))
        datas.append(HCListCellItem.init(title: "当前版本", detailTitle: Bundle.main.version, shwoArrow: false, cellIdentifier: HCBaseListCell_identifier))
        
        listDataObser.value = [SectionModel.init(model: 0, items: datas)]
    }
    
    public func cellModel(for indexPath: IndexPath) ->HCListCellItem {
        return listDataObser.value[indexPath.section].items[indexPath.row]
    }
}
