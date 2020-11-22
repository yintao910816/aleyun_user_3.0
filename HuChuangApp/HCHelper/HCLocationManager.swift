//
//  HCLocationManager.swift
//  HuChuangApp
//
//  Created by yintao on 2019/8/16.
//  Copyright © 2019 sw. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift

class HCLocationManager: NSObject {

    private var locationManager: CLLocationManager!
    private var geocoder: CLGeocoder!
    
    public let locationSubject = PublishSubject<CLLocation?>()
    public let addressSubject = PublishSubject<([AnyHashable : Any]?, String?, CLLocationCoordinate2D)>()

    override init() {
        super.init()
                
        checkAuthorized()
    }
    
    private func checkAuthorized() {
        if (CLLocationManager.locationServicesEnabled()){
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
                reLocationAction()
            default:
                NoticesCenter.alert(title: "提示", message: "未开启定位权限", cancleTitle: "取消", okTitle: "去开启") { [unowned self] in
                    self.locationSubject.onNext(CLLocation.init(latitude: 30.5, longitude: 114.3))
                } callBackOK: {
                    HCHelper.appSetting()
                }
            }
        }else {
            NoticesCenter.alert(message: "设备不支持定位功能")
            locationSubject.onNext(CLLocation.init(latitude: 30.5, longitude: 114.3))
        }
    }
    
    deinit {
        if locationManager != nil {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
        }
    }
    
    private func reLocationAction(){
        locationManager = CLLocationManager.init()
        geocoder = CLGeocoder.init()
        locationManager.delegate = self
//        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest//定位最佳
        locationManager.distanceFilter = 500.0//更新距离
        locationManager.requestWhenInUseAuthorization()
    }
    
}

extension HCLocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (CLLocationManager.locationServicesEnabled()){
            switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                if (CLLocationManager.locationServicesEnabled()){
                    locationManager.startUpdatingLocation()
                    print("定位开始")
                }else {
                    locationSubject.onNext(CLLocation.init(latitude: 30.5, longitude: 114.3))
                }
            default:
                locationSubject.onNext(CLLocation.init(latitude: 30.5, longitude: 114.3))
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        PrintLog("获取经纬度发生错误:\(error)")
        locationSubject.onNext(CLLocation.init(latitude: 30.5, longitude: 114.3))
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let thelocations:NSArray = locations as NSArray
        let location = thelocations.lastObject as! CLLocation
        locationManager.stopUpdatingLocation()
        
        getAddress(for: location.coordinate)
        
        locationSubject.onNext(location)
    }

}

extension HCLocationManager {
    
    private func getAddress(for coor: CLLocationCoordinate2D) {
        let locations = CLLocation.init(latitude: coor.latitude, longitude: coor.longitude)
        geocoder.reverseGeocodeLocation(locations) { [weak self] (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?.first, let city = placemark.addressDictionary?["City"] as? String {
                    PrintLog(placemark.addressDictionary)

                    var resultCity: NSString = city as NSString
                    if city.contains("市") {
                        resultCity = resultCity.replacingOccurrences(of: "市", with: "") as NSString
                    }
                    self?.addressSubject.onNext((placemark.addressDictionary, resultCity as String, coor))
                }
            }else {
                self?.addressSubject.onError(error!)
            }
        }
    }
}
