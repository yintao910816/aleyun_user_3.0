//
//  HCSettingViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/9/30.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation

import RxSwift
import RxDataSources

class HCUserInfoViewModel: BaseViewModel {
    
    private var cellItems: [SectionModel<Int, HCListCellItem>] = []
    
    public let datasource = Variable([SectionModel<Int, HCListCellItem>]())
    
    public let finishEdit = PublishSubject<UIImage?>()
    
    override init() {
        super.init()
        
        finishEdit
            .filter({ [unowned self] image -> Bool in
                if image == nil {
                    self.hud.failureHidden("请选择头像")
                    return false
                }
                return true
            })
            ._doNext(forNotice: hud)
            .flatMap({ [unowned self] image -> Observable<HCUserModel> in
                return self.requestEditIcon(icon: image!).concatMap{ self.requestUpdateUserInfo(iconPath: $0.filePath) }
            })
            .subscribe(onNext: { [weak self] user in
                HCHelper.saveLogin(user: user)
                self?.hud.noticeHidden()
                self?.popSubject.onNext(Void())
                }, onError: { [weak self] error in
                    self?.hud.failureHidden(self?.errorMessage(error))
            })
            .disposed(by: disposeBag)

        HCHelper.share.userInfoHasReload
            .subscribe(onNext: { [weak self] _ in
                self?.reloadUserInfo()
            })
            .disposed(by: disposeBag)
        
        reloadUserInfo()
    }
    
    private func reloadUserInfo() {
        let userModel = HCHelper.share.userInfoModel ?? HCUserModel()
        cellItems = [SectionModel.init(model: 0, items: [HCListCellItem(title: "昵称",
                                                                        detailTitle: userModel.name,
                                                                        titleColor: RGB(60, 60, 60),
                                                                        detailTitleColor: RGB(173, 173, 173),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: "editNickNameSegue"),
                                                         HCListCellItem(title: "性别",
                                                                        detailTitle: userModel.sexText,
                                                                        titleColor: RGB(60, 60, 60),
                                                                        detailTitleColor: RGB(173, 173, 173),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: "editSexSegue"),
                                                         HCListCellItem(title: "地区",
                                                                        detailTitle: userModel.cityName,
                                                                        titleColor: RGB(60, 60, 60),
                                                                        detailTitleColor: RGB(173, 173, 173),
                                                                        cellIdentifier: HCListDetailCell_identifier,
                                                                        segue: "editUserCitySegue"),
//                                                         HCListCellItem(title: "手机号",
//                                                                        detailTitle: userModel.mobileInfo,
//                                                                        titleColor: RGB(60, 60, 60),
//                                                                        detailTitleColor: RGB(173, 173, 173),
//                                                                        cellIdentifier: HCListDetailCell_identifier,
//                                                                        segue: ""),
//                                                         HCListCellItem(title: "地区",
//                                                                        detailTitle: "武汉",
//                                                                        titleColor: RGB(60, 60, 60),
//                                                                        detailTitleColor: RGB(173, 173, 173),
//                                                                        cellIdentifier: HCListDetailCell_identifier,
//                                                                        segue: "")
        ])]
        
        datasource.value = cellItems
    }
    
    /// 获取当前cell的数据源
    public func cellModel(for indexPath: IndexPath) ->HCListCellItem {
        return cellItems[indexPath.section].items[indexPath.row]
    }
    
    private func requestEditIcon(icon: UIImage) ->Observable<UpLoadIconModel>{
        return HCProvider.request(.uploadIcon(image: icon))
            .map(model: UpLoadIconModel.self)
            .asObservable()
    }
    
    private func requestUpdateUserInfo(iconPath: String) ->Observable<HCUserModel> {
        guard let user = HCHelper.share.userInfoModel else {
            hud.failureHidden("用户信息获取失败，请重新登录") {
                HCHelper.presentLogin()
            }
            return Observable.empty()
        }
        
        let params: [String: String] = ["patientId": user.uid,
                                        "name": user.name,
                                        "sex": "\(user.sex)",
                                        "headPath": iconPath,
                                        "synopsis": user.synopsis,
                                        "birthday": user.birthday]
        
        return HCProvider.request(.updateInfo(param: params))
            .map(model: HCUserModel.self)
            .asObservable()
    }

}
