//
//  HCRealNameAuthorViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/17.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HCRealNameAuthorViewModel: BaseViewModel {
    public let listItemSubject = PublishSubject<[HCListCellItem]>()

    init(commit: Driver<Void>) {
        super.init()
        
        reloadSubject
            .subscribe(onNext: { [weak self] in self?.prepareData() })
            .disposed(by: disposeBag)
    }
}

extension HCRealNameAuthorViewModel {
    
    private func prepareData() {
        var items: [HCListCellItem] = []
        
        var nameItem = HCListCellItem()
        nameItem.title = "姓名"
        nameItem.cellIdentifier = HCListDetailInputCell_identifier
        nameItem.placeholder = "请输入"
        nameItem.detailInputTextAlignment = .right
        nameItem.shwoArrow = false
        items.append(nameItem)
        
        var genderItem = HCListCellItem()
        genderItem.shwoArrow = false
        genderItem.title = "性别"
        genderItem.detailTitle = "0"
        genderItem.cellIdentifier = HCListSexCell_identifier
        items.append(genderItem)
        
        var birthItem = HCListCellItem()
        birthItem.title = "出生日期"
        birthItem.detailTitle = "请选择"
        birthItem.cellIdentifier = HCListDetailCell_identifier
        items.append(birthItem)

        var idTypeItem = HCListCellItem()
        idTypeItem.title = "证件类型"
        idTypeItem.detailTitle = "请选择"
        idTypeItem.cellIdentifier = HCListDetailCell_identifier
        items.append(idTypeItem)

        var idNumItem = HCListCellItem()
        idNumItem.title = "证件号"
        idNumItem.cellIdentifier = HCListDetailInputCell_identifier
        idNumItem.placeholder = "请输入"
        idNumItem.detailInputTextAlignment = .right
        idNumItem.shwoArrow = false
        items.append(idNumItem)

        listItemSubject.onNext(items)
    }

}
/**
 
 {"realName":"张三","sex":1,"birthDay":"1991-01-01","certificateType":"身份证",
 "certificateNo":"429005198907041123"}

 */
