//
//  HCFindDoctorViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

import RxSwift
import RxDataSources

class HCFindDoctorViewModel: BaseViewModel {
    
    public var datasource = Variable([SectionModel<Int, HCListCellItem>]())
    
    override init() {
        super.init()
        
        datasource.value = [SectionModel.init(model: 0, items: [HCListCellItem(title: "您的年龄",
                                                                               cellIdentifier: HCListDetailCell_identifier),
                                                                HCListCellItem(title: "平均月经周期",
                                                                               detailTitle: "不确定？",
                                                                               cellIdentifier: HCListDetailNewTypeCell_identifier),
                                                                HCListCellItem(title: "平均行经天数",
                                                                               cellIdentifier: HCListDetailCell_identifier),
                                                                HCListCellItem(title: "最近一次月经来潮时间",
                                                                               cellIdentifier: HCListDetailCell_identifier),
                                                                HCListCellItem(title: "下一步",
                                                                               titleColor: RGB(255, 102, 149),
                                                                               cellHeight: 80,
                                                                               cellIdentifier: HCListButtonCell_identifier,
                                                                               buttonBorderColor: RGB(255, 102, 149).cgColor,
                                                                               buttonEdgeInsets: .init(top: 35,
                                                                                                       left: (UIScreen.main.bounds.width - 110) / 2.0,
                                                                                                       bottom: 15,
                                                                                                       right: (UIScreen.main.bounds.width - 110) / 2.0))])]
    }
    
    /// 获取当前cell的数据源
    public func cellModel(for indexPath: IndexPath) ->HCListCellItem {
        return datasource.value[indexPath.section].items[indexPath.row]
    }
}
