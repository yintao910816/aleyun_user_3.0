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
    
    public func loadCity(model: HCAreaProvinceModel) {
        if model.name == "热门地区" {
            requestHotCity()
        }else {
            requestCity(id: model.id)
        }
    }
}

extension HCAreaManager {
    
    private func requestProvince() {
        HCProvider.request(.allProvice)
            .map(models: HCAreaProvinceModel.self)
            .map({ datas -> [HCAreaProvinceModel] in
                var tempDatas: [HCAreaProvinceModel] = []
                let hotModel = HCAreaProvinceModel()
                hotModel.id = "-1"
                hotModel.name = "热门地区"

                tempDatas.append(hotModel)
                tempDatas.append(contentsOf: datas)
                return tempDatas
            })
            .do(onSuccess: { [weak self] _ in self?.requestHotCity() })
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
        }
    }
    
    private func requestHotCity() {
        HCProvider.request(.allHotCity)
            .map(models: HCHotAreaCityModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.cityDataSignal.onNext(("-1", $0))
            }) { [weak self] _ in
                self?.cityDataSignal.onNext(("-1", [HCAreaCityModel]()))
        }
        .disposed(by: disposeBag)
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

class HCHotAreaCityModel: HCAreaCityModel {
    var code: String = ""
    var firstLetter: String = ""
    var hotCityFlag: String = ""
    var level: Int = 0
    var parent_id: String = ""
    var sort: Int = 0
}
