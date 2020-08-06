//
//  HCEditUserCityModel.swift
//  HuChuangApp
//
//  Created by yintao on 2020/1/3.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCEditUserCityViewModel: BaseViewModel {
    
    public let allCitysDataObser = Variable([HCAllCityItemModel]())
    public var sectionTitles: [String] = []
    public let finishEdit = PublishSubject<HCCityItemModel?>()

    override init() {
        super.init()
        
        reloadSubject.subscribe(onNext: { [weak self] in
            self?.requestAllCitys()
        })
        .disposed(by: disposeBag)
        
        finishEdit
            ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] in
                guard let m = $0 else {
                    self?.popSubject.onNext(Void())
                    return
                }
                self?.requestEditCityName(model: m)
            })
            .disposed(by: disposeBag)
    }
    
    private func requestAllCitys() {
        HCProvider.request(.allCity)
            .map(models: HCAllCityItemModel.self)
            .asObservable()
            .do(onNext: { [weak self] datas in
                self?.sectionTitles.removeAll()
                for item in datas {
                    self?.sectionTitles.append(item.key)
                }
            })
            .bind(to: allCitysDataObser)
            .disposed(by: disposeBag)
    }
    
    private func requestEditCityName(model: HCCityItemModel) {
        guard let user = HCHelper.share.userInfoModel else {
            hud.failureHidden("用户信息获取失败，请重新登录") {
                HCHelper.presentLogin()
            }
            return
        }
        let params: [String: String] = ["patientId": user.uid,
                                        "name": user.name,
                                        "sex": "\(user.sex)",
                                        "headPath": user.headPath,
                                        "synopsis": user.synopsis,
                                        "birthday": user.birthday,
                                        "areaCode": model.id]

        HCProvider.request(.updateInfo(param: params))
            .map(model: HCUserModel.self)
            .subscribe(onSuccess: { [weak self] user in
                HCHelper.saveLogin(user: user)
                self?.hud.noticeHidden()
                self?.popSubject.onNext(Void())
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
        }
        .disposed(by: disposeBag)
    }
}
