//
//  HCHospitalListViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/26.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCHospitalListViewModel: RefreshVM<HCHospitalListItemModel> {
    
    private var slideData: [TYSlideItemModel] = []

    private var searchWords: String = ""
    private var areaCode: String = ""
    private var level: String = ""

    public let slideDataSignal = PublishSubject<([TYSlideItemModel])>()

    public let areaFilterSubject = PublishSubject<(HCAreaProvinceModel, HCAreaCityModel)>()
    public let levelFilterSubject = PublishSubject<String>()
    public let keyWordsFilterSubject = PublishSubject<String>()

    override init() {
        super.init()
        
        areaFilterSubject
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.areaCode = $0.1.id
                strongSelf.slideData.first?.title = $0.1.name
                strongSelf.slideDataSignal.onNext(strongSelf.slideData)
                strongSelf.requestData(true)
            })
            .disposed(by: disposeBag)
        
        keyWordsFilterSubject
            .subscribe(onNext: { [unowned self] in
                self.searchWords = $0
                self.requestData(true)
            })
            .disposed(by: disposeBag)
        
        levelFilterSubject
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self else { return }
//                var needReload = false
//                if $0 == "默认排序" {
//                    strongSelf.sortType = "1"
//                    needReload = true
//                }else if $0 == "问诊数" {
//                    strongSelf.sortType = "2"
//                    needReload = true
//                }else if $0 == "好评率" {
//                    strongSelf.sortType = "3"
//                    needReload = true
//                }
//                if needReload {
//                    strongSelf.slideData[1].title = $0
//                    strongSelf.slideDataSignal.onNext(strongSelf.slideData)
//                    strongSelf.requestData(true)
//                }
            })
            .disposed(by: disposeBag)

        
        reloadSubject
            .subscribe(onNext: { [weak self] in self?.prepareData() })
            .disposed(by: disposeBag)
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(true)
        
        HCProvider.request(.hospitalList(searchWords: searchWords, areaCode: areaCode, level: level))
            .map(models: HCHospitalListItemModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0, 1)
            })
            .disposed(by: disposeBag)
    }
}

extension HCHospitalListViewModel {
    
    private func prepareData() {
        slideData = TYSlideItemModel.createHospitalListData()
        slideDataSignal.onNext(slideData)
    }
}
