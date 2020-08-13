//
//  HCAccountSettingViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/13.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCAccountSettingViewModel: BaseViewModel {
    
    public let listItemSubject = PublishSubject<[HCListCellItem]>()
    
    override init() {
        super.init()
        
        HCHelper.share.userInfoHasReload
            .subscribe(onNext: { [weak self] in self?.prepareData(user: $0) })
            .disposed(by: disposeBag)
        
        reloadSubject
            .subscribe(onNext: { [weak self] in
                if let user = HCHelper.share.userInfoModel {
                    self?.prepareData(user: user)
                }
            })
            .disposed(by: disposeBag)
        
        HCProvider.request(.selectInfo)
            .map(model: HCUserModel.self)
            .subscribe(onSuccess: { user in
                HCHelper.saveLogin(user: user)
            }) { error in
                PrintLog(error)
            }
            .disposed(by: disposeBag)
    }
    
}

extension HCAccountSettingViewModel {
    
    private func prepareData(user: HCUserModel) {
        var items: [HCListCellItem] = []
        
        var avatarItem = HCListCellItem()
        avatarItem.title = "头像"
        avatarItem.iconType = .userIcon
        avatarItem.cellIdentifier = HCListDetailIconCell_identifier
        avatarItem.cellHeight = 80
        avatarItem.detailIcon = user.headPath
        items.append(avatarItem)
        
        var accountItem = HCListCellItem()
        accountItem.title = "账号"
        accountItem.detailTitle = user.account
        accountItem.cellIdentifier = HCListDetailCell_identifier
        items.append(accountItem)
        
        var nickNameItem = HCListCellItem()
        nickNameItem.title = "昵称"
        nickNameItem.detailTitle = user.name
        nickNameItem.cellIdentifier = HCListDetailCell_identifier
        items.append(nickNameItem)

        var realItem = HCListCellItem()
        realItem.title = "实名信息"
        realItem.detailTitle = user.realName
        realItem.cellIdentifier = HCListDetailCell_identifier
        items.append(realItem)

        listItemSubject.onNext(items)
    }
}
