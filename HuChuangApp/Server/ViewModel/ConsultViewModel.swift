//
//  ConsultViewModel.swift
//  HuChuangApp
//
//  Created by yintao on 2019/8/14.
//  Copyright © 2019 sw. All rights reserved.
//

import Foundation
import RxSwift

class ConsultViewModel: RefreshVM<HCDoctorItemModel> {
    
    private var areaCode: String = ""
    private var lat: String = ""
    private var lng: String = ""
    
    let webRefreshSubject = PublishSubject<String>()
    
    private var locationManager: HCLocationManager!
    
    override init() {
        super.init()
                
        reloadSubject
        ._doNext(forNotice: hud)
            .subscribe(onNext: { [weak self] in
                self?.prepareRequestData()
            })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.recommendDoctor(areaCode: areaCode, lat: lat, lng: lng))
            .map(models: HCDoctorItemModel.self)
            .subscribe(onSuccess: { [weak self] data in
                self?.hud.noticeHidden()
                self?.updateRefresh(refresh, data, data.count)
            }) { [weak self] error in
                self?.hud.failureHidden(self?.errorMessage(error))
                self?.revertCurrentPageAndRefreshStatus()
        }
        .disposed(by: disposeBag)
    }
}

extension ConsultViewModel {
    
    private func prepareRequestData() {
        locationManager = HCLocationManager()
        
        Observable.combineLatest(locationManager.addressSubject.asObserver(), requestAllCity()) { ($0,$1) }
            .subscribe(onNext: { [weak self] data in
                if let geoCity = data.0.1, geoCity.count > 0 {
                    for item in data.1 {
                        for city in item.list {
                            if city.name.contains(geoCity) {
                                self?.areaCode = city.id
                                break
                            }
                        }
                    }
                }
                
                self?.requestData(true)
            }, onError: { [weak self] error in
                self?.requestData(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func requestAllCity() ->Observable<[HCAllCityItemModel]> {
        return HCProvider.request(.allCity)
            .map(models: HCAllCityItemModel.self)
            .asObservable()
    }
}
