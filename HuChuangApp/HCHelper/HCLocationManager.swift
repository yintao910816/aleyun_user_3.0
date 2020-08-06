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
        locationManager = CLLocationManager.init()
        geocoder = CLGeocoder.init()
        
        reLocationAction()
    }
    
    deinit {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
    }
    
    private func reLocationAction(){
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
                    locationSubject.onNext(nil)
                }
            default:
                break
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        PrintLog("获取经纬度发生错误:\(error)")
        locationSubject.onNext(nil)
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
