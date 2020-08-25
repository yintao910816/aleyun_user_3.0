//
//  HCExpertConsultationViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCExpertConsultationViewModel: BaseViewModel {
    
    private var locationManager: HCLocationManager!
    
    override init() {
        super.init()
        
        requestBanner()
        requestStatisticsDoctorHopital()
        prepareRequestMyDoctorData()
    }
}

extension HCExpertConsultationViewModel {
    
    private func requestBanner() {
        HCProvider.request(.selectBanner(code: .bannerdoctor))
            .mapJSON()
            .subscribe(onSuccess: { [weak self] _ in
                
            })
            .disposed(by: disposeBag)
    }
    
    private func requestStatisticsDoctorHopital() ->Observable<HCStatisticsDoctorHopitalModel> {
        return HCProvider.request(.statisticsDoctorHopital)
            .map(model: HCStatisticsDoctorHopitalModel.self)
            .asObservable()
            .catchErrorJustReturn(HCStatisticsDoctorHopitalModel())
    }
    
    private func prepareRequestMyDoctorData() {
        locationManager = HCLocationManager()
        
        locationManager.locationSubject
            .filter { $0 != nil }
            .flatMap { location -> Observable<HCDoctorListItemModel> in
                return HCProvider.request(.myDoctor(lng: "\(location!.coordinate.longitude)", lat: "\(location!.coordinate.latitude)"))
                    .map(model: HCDoctorListItemModel.self)
                    .asObservable()
                    .catchErrorJustReturn(HCDoctorListItemModel())
        }
        .subscribe(onNext: { data in
            
        })
        .disposed(by: disposeBag)
    
        
//        Observable.combineLatest(locationManager.addressSubject.asObserver(), requestAllCity()) { ($0,$1) }
//            .subscribe(onNext: { [weak self] data in
//                if let geoCity = data.0.1, geoCity.count > 0 {
//                    for item in data.1 {
//                        for city in item.list {
//                            if city.name.contains(geoCity) {
//                                self?.areaCode = city.id
//                                break
//                            }
//                        }
//                    }
//                }
//
//                self?.requestData(true)
//            }, onError: { [weak self] error in
//                self?.requestData(true)
//            })
//            .disposed(by: disposeBag)
    }

}
