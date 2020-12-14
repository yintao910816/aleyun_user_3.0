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
    public let listItemSource = Variable([HCListCellItem]())

    init(commit: Driver<Void>) {
        super.init()
        
        commit
            .drive(onNext: { [unowned self] in self.requestRealNameAuth() })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in self?.prepareData() })
            .disposed(by: disposeBag)
    }
    
    private func requestRealNameAuth() {
        let realName = listItemSource.value[0].detailTitle
        let sex = listItemSource.value[1].detailTitle
        let birthDay = listItemSource.value[2].detailTitle
        let certificateType = listItemSource.value[3].detailTitle
        let certificateNo = listItemSource.value[4].detailTitle
        
        var remindText: String = ""
        if realName.count == 0 {
            remindText = "请输入姓名"
        }else if birthDay == "请选择" {
            remindText = "请选择出生日期"
        }else if certificateType == "请选择" {
            remindText = "请选择证件类型"
        }else if certificateNo.count == 0 {
            remindText = "请输入证件号"
        }

        if remindText.count > 0 {
            NoticesCenter.alert(message: remindText)
            return
        }
        
        hud.noticeLoading()
        HCProvider.request(.realNameAuth(realName: realName, sex: sex, birthDay: birthDay, certificateType: certificateType, certificateNo: certificateNo))
            .map(model: HCUserModel.self)
            .subscribe(onSuccess: { [weak self] in
                HCHelper.saveLogin(user: $0)
                NotificationCenter.default.post(name: NotificationName.User.LoginSuccess, object: nil)
                self?.popSubject.onNext(Void())
            }) { [weak self] in
                self?.hud.failureHidden(self?.errorMessage($0))
        }
        .disposed(by: disposeBag)
    }
}

extension HCRealNameAuthorViewModel {
    
    private func prepareData() {
        var items: [HCListCellItem] = []
        
        let nameItem = HCListCellItem()
        nameItem.title = "姓名"
        nameItem.cellIdentifier = HCListDetailInputCell_identifier
        nameItem.placeholder = "请输入"
        nameItem.detailInputTextAlignment = .right
        nameItem.shwoArrow = false
        nameItem.inputSize = .init(width: 100, height: 30)
        items.append(nameItem)
        
        let genderItem = HCListCellItem()
        genderItem.shwoArrow = false
        genderItem.title = "性别"
        genderItem.detailTitle = "0"
        genderItem.cellIdentifier = HCListSexCell_identifier
        items.append(genderItem)
        
        let birthItem = HCListCellItem()
        birthItem.title = "出生日期"
        birthItem.detailTitle = "请选择"
        birthItem.cellIdentifier = HCListDetailCell_identifier
        items.append(birthItem)

        let idTypeItem = HCListCellItem()
        idTypeItem.title = "证件类型"
        idTypeItem.detailTitle = "请选择"
        idTypeItem.cellIdentifier = HCListDetailCell_identifier
        items.append(idTypeItem)

        let idNumItem = HCListCellItem()
        idNumItem.title = "证件号"
        idNumItem.cellIdentifier = HCListDetailInputCell_identifier
        idNumItem.placeholder = "请输入"
        idNumItem.detailInputTextAlignment = .right
        idNumItem.inputSize = .init(width: 150, height: 30)
        idNumItem.shwoArrow = false
        items.append(idNumItem)

        listItemSource.value = items
    }

}
/**
 
 {"realName":"张三","sex":1,"birthDay":"1991-01-01","certificateType":"身份证",
 "certificateNo":"429005198907041123"}

 */
