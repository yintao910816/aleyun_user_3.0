//
//  HCExpertConsultationViewModel.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import Foundation
import RxSwift

class HCExpertConsultationViewModel: RefreshVM<HCDoctorListItemModel> {
    
    private var areaCode: String = ""
    private var sortType: String = ""
    private var consultType: String = ""
    
    private var slideData: [TYSlideItemModel] = []
    
    private var locationManager: HCLocationManager!
    
    public let headerDataSignal = PublishSubject<([HCBannerModel], HCStatisticsDoctorHopitalModel, [HCDoctorListItemModel], [TYSlideItemModel])>()
    public let slideDataSignal = PublishSubject<([TYSlideItemModel])>()

    public let areaFilterSubject = PublishSubject<(HCAreaProvinceModel, HCAreaCityModel)>()
    public let sortedFilterSubject = PublishSubject<String>()
    public let consultTypeFilterSubject = PublishSubject<String>()

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
        
        sortedFilterSubject
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                var needReload = false
                var title = $0
                if $0 == "默认排序" || $0.count == 0 {
                    strongSelf.sortType = ""
                    needReload = true
                    title = "推荐排序"
                }else if $0 == "职称" {
                    strongSelf.sortType = "1"
                    needReload = true
                }else if $0 == "咨询数" {
                    strongSelf.sortType = "2"
                    needReload = true
                }else if $0 == "好评率" {
                    strongSelf.sortType = "3"
                    needReload = true
                }
                if needReload {
                    strongSelf.slideData[1].title = title
                    strongSelf.slideDataSignal.onNext(strongSelf.slideData)
                    strongSelf.requestData(true)
                }
            })
            .disposed(by: disposeBag)
        
        consultTypeFilterSubject
            .subscribe(onNext: { [weak self] in
                guard let strongSelf = self else { return }
                var needReload = false
                var title = $0
                if $0 == "全部" || $0.count == 0 {
                    strongSelf.consultType = ""
                    needReload = true
                    title = "咨询方式"
                }else if $0 == "图文" {
                    strongSelf.consultType = "1"
                    needReload = true
                }else if $0 == "视频" {
                    strongSelf.consultType = "2"
                    needReload = true
                }
                if needReload {
                    strongSelf.slideData[2].title = title
                    strongSelf.slideDataSignal.onNext(strongSelf.slideData)
                    strongSelf.requestData(true)
                }
            })
            .disposed(by: disposeBag)

        reloadSubject
            .subscribe(onNext: { [weak self] in self?.prapareData() })
            .disposed(by: disposeBag)
    }
    
    public var sortedIdentifier: String {
        get {
            if slideData[1].title == "推荐排序" {
                return "默认排序"
            }
            return slideData[1].title
        }
    }

    public var consultTypeIdentifier: String {
        get {
            if slideData[2].title == "咨询方式" {
                return "全部"
            }
            return slideData[2].title
        }
    }
    
    override func requestData(_ refresh: Bool) {
        super.requestData(refresh)
        
        HCProvider.request(.doctorList(areaCode: self.areaCode,
                                       sortType: self.sortType,
                                       consultType: self.consultType,
                                       pageSize: pageModel.pageSize,
                                       pageNum: pageModel.currentPage))
            .map(result: HCHCDoctorListModel.self)
            .subscribe(onSuccess: { [weak self] in
                self?.updateRefresh(refresh, $0.data?.records, $0.data?.total ?? 0)
                }, onError: { [weak self] _ in
                    self?.revertCurrentPageAndRefreshStatus()
            })
            .disposed(by: disposeBag)
    }
    
}

extension HCExpertConsultationViewModel {
    
    private func prapareData() {
        Observable.combineLatest(requestBanner(), requestStatisticsDoctorHopital(), requestMyDoctorData()) { ($0, $1, $2) }
            .subscribe(onNext: { [weak self] data in
                self?.slideData = TYSlideItemModel.createExpertConsultationData()
                self?.headerDataSignal.onNext((data.0, data.1, data.2, self?.slideData ?? []))
            })
            .disposed(by: disposeBag)
    }
    
    private func requestBanner() ->Observable<[HCBannerModel]> {
        return HCProvider.request(.selectBanner(code: .bannerdoctor))
            .map(models: HCBannerModel.self)
            .asObservable()
            .catchErrorJustReturn([HCBannerModel]())
    }
    
    private func requestStatisticsDoctorHopital() ->Observable<HCStatisticsDoctorHopitalModel> {
        return HCProvider.request(.statisticsDoctorHopital)
            .map(model: HCStatisticsDoctorHopitalModel.self)
            .asObservable()
            .catchErrorJustReturn(HCStatisticsDoctorHopitalModel())
    }
    
    private func requestMyDoctorData() ->Observable<[HCDoctorListItemModel]> {
        if UIDevice.current.isSimulator() {
            return HCProvider.request(.myDoctor(lng: "114.3", lat: "30.5"))
                .map(models: HCDoctorListItemModel.self)
                .asObservable()
                .catchErrorJustReturn([HCDoctorListItemModel]())
        }
        
        if locationManager != nil {
            locationManager = nil
        }
        locationManager = HCLocationManager()
        
        return locationManager.locationSubject
            .filter { $0 != nil }
            .flatMap { location -> Observable<[HCDoctorListItemModel]> in
                if let loc = location {
                    return HCProvider.request(.myDoctor(lng: "\(loc.coordinate.longitude)", lat: "\(loc.coordinate.latitude)"))
                        .map(models: HCDoctorListItemModel.self)
                        .asObservable()
                        .catchErrorJustReturn([HCDoctorListItemModel]())
                }else {
                    return Observable.just([HCDoctorListItemModel]())
                }
        }
    }

}
