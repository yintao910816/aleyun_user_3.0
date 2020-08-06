//
//  MineViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/2/13.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

class MineViewModel: BaseViewModel, VMNavigation {
    
    let userInfo = PublishSubject<HCUserModel>()
    let datasource = PublishSubject<[SectionModel<Int, MenuListItemModel>]>()
    let pushH5Subject = PublishSubject<MenuListItemModel>()
    let cellDidSelectedSubject = PublishSubject<MenuListItemModel>()

    private var currentType: H5Type?
        
    override init() {
        super.init()
             
        pushH5Subject
            ._doNext(forNotice: hud)
            .flatMap{ [unowned self] in self.requestH5(type: $0.h5Type) }
            .subscribe(onNext: { [unowned self] model in
                self.hud.noticeHidden()
                self.pushH5(model: model)
                }, onError: { [unowned self] error in
                    self.hud.failureHidden(self.errorMessage(error))
            })
            .disposed(by: disposeBag)

        cellDidSelectedSubject
            .subscribe(onNext: {
                if $0.h5Type == .share {
                    HCAccountManager.presentShare(thumbURL: UIImage(named: "app_icon")!,
                                                  title: "爱乐孕",
                                                  descr: "您的好孕帮手",
                                                  webpageUrl: HCAccountManager.appstoreURL())
                }else {
                    HCHelper.pushLocalH5(type: $0.h5Type)
                }
            })
            .disposed(by: disposeBag)

        HCHelper.share.userInfoHasReload
            .subscribe(onNext: { [unowned self] user in
                self.userInfo.onNext(user)
            })
            .disposed(by: disposeBag)
        
        reloadSubject.subscribe(onNext: { [unowned self] in self.requestUserInfo() })
            .disposed(by: disposeBag)
    }
    
    private func requestH5(type: H5Type) ->Observable<H5InfoModel> {
        currentType = type
        
        return HCProvider.request(.unitSetting(type: type))
            .map(model: H5InfoModel.self)
            .asObservable()
    }

    private func requestUserInfo() {
        let dataList = [SectionModel.init(model: 0, items: [MenuListItemModel.createModel(titleIcon: "goumaikechen",
                                                                                          title: "经期设置",
                                                                                          h5Type: .menstrualSetting),
                                                            MenuListItemModel.createModel(titleIcon: "gongjuxiang",
                                                                                          title: "健康档案",
                                                                                          h5Type: .healthRecordsUser),
                                                            MenuListItemModel.createModel(titleIcon: "shoucang",
                                                                                          title: "我的医生",
                                                                                          h5Type: .myDoctor)]),
                        SectionModel.init(model: 1, items: [MenuListItemModel.createModel(titleIcon: "shouhuodizhi",
                                                                                          title: "我的卡券",
                                                                                          h5Type: .voucherCenter)]),
                        SectionModel.init(model: 2, items: [MenuListItemModel.createModel(titleIcon: "my_icon_feedback",
                                                                                          title: "用户反馈",
                                                                                          h5Type: .feedback),
                                                            MenuListItemModel.createModel(titleIcon: "yijianfankui",
                                                                                          title: "帮助中心",
                                                                                          h5Type: .helpCenter),
                                                            MenuListItemModel.createModel(titleIcon: "my_icon_recommend",
                                                                                          title: "推荐给爱乐孕好友",
                                                                                          h5Type: .share)])]
        
        datasource.onNext(dataList)
        
        HCProvider.request(.selectInfo)
            .map(model: HCUserModel.self)
            .subscribe(onSuccess: { [unowned self] user in
                HCHelper.saveLogin(user: user)
                self.userInfo.onNext(user)
            }) { error in
                PrintLog(error)
            }
            .disposed(by: disposeBag)
    }
    
    private func pushH5(model: H5InfoModel) {
        if currentType == .healthRecordsUser {
            pushH5(type: .healthRecordsUser)
            currentType = nil
            return
        }
        
        guard model.setValue.count > 0 else { return }
        
        if model.setValue.count > 0 {
            var url = model.setValue
            PrintLog("h5拼接前地址：\(url)")
            if url.contains("?") == false {
                url += "?token=\(userDefault.token)&unitId=\(userDefault.unitId)"
            }else {
                url += "&token=\(userDefault.token)&unitId=\(userDefault.unitId)"
            }
            PrintLog("h5拼接后地址：\(url)")
            
            HomeViewModel.push(BaseWebViewController.self, ["url": url])
        }else {
            hud.failureHidden("功能暂不开放")
        }
        
        currentType = nil

//        let url = "\(model.setValue)?token=\(userDefault.token)&unitId=\(AppSetup.instance.unitId)"
//        HomeViewModel.push(BaseWebViewController.self, ["url": url])
    }

    private func pushH5(type: H5Type) {
        var url = ""
        switch type {
        case .healthRecordsUser:
            url = "\(type.getLocalUrl())?token=\(userDefault.token)&unitId=\(userDefault.unitId)&isUserInfoBack=true"
        default:
            break
        }
        if url.count > 0 {
            HomeViewModel.push(BaseWebViewController.self, ["url": url])
        }
    }
}

class MenuListItemModel {
    var titleIcon: UIImage?
    var title: String = ""
    
    var h5Type: H5Type = .underDev
    
    class func createModel(titleIcon: String = "", title: String, h5Type: H5Type) ->MenuListItemModel {
        let model = MenuListItemModel()
        model.title = title
        model.h5Type = h5Type
        if titleIcon.count > 0 { model.titleIcon = UIImage.init(named: titleIcon) }
        return model
    }
}
