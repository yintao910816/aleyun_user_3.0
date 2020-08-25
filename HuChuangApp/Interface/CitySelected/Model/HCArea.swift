//
//  HCArea.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCAreaManager {
    
    private let disposeBag = DisposeBag()
    
    public var provinceDataSignal = PublishSubject<[HCAreaProvinceModel]>()
    public var cityDataSignal = PublishSubject<(String, [HCAreaCityModel])>()

    init() {
        
    }
    
    public func prepareData() {
        requestProvince()
    }
    
    public func loadCity(id: String) {
        requestCity(id: id)
    }
}

extension HCAreaManager {
    
    private func requestProvince() {
        HCProvider.request(.allProvice)
            .map(models: HCAreaProvinceModel.self)
            .do(onSuccess: { [weak self] in self?.requestCity(id: $0.first?.id ?? "") })
            .asObservable()
            .catchErrorJustReturn([HCAreaProvinceModel]())
            .bind(to: provinceDataSignal)
            .disposed(by: disposeBag)
    }
    
    private func requestCity(id: String) {
        if id.count > 0 {
            HCProvider.request(.city(id: id))
                .map(models: HCAreaCityModel.self)
                .subscribe(onSuccess: { [weak self] in
                    self?.cityDataSignal.onNext((id, $0))
                }) { [weak self] _ in
                    self?.cityDataSignal.onNext((id, [HCAreaCityModel]()))
            }
            .disposed(by: disposeBag)
//                .map{ (id, $0) }
//                .asObservable()
//                .catchErrorJustReturn(("", [HCAreaCityModel]()))
//                .bind(to: cityDataSignal)
//                .disposed(by: disposeBag)
        }
    }

}

//MARK:
//MARK: Model
class HCAreaProvinceModel: HJModel {
    var id: String = ""
    var name: String = ""
}

class HCAreaCityModel: HJModel {
    var id: String = ""
    var name: String = ""
}
