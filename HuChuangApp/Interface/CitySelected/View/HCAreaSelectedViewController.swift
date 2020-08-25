//
//  HCAreaSelectedViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

import RxSwift

class HCAreaSelectedViewController: UIViewController {

    private var areaManager: HCAreaManager!
    private let disposeBag = DisposeBag()
    
    private var container: HCAreaSelectedContainer!
    
    public var cityClicked: (((HCAreaProvinceModel, HCAreaCityModel))->())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        container = HCAreaSelectedContainer.init(frame: view.bounds)
        view.addSubview(container)
        
        areaManager = HCAreaManager()
        areaManager.prepareData()
        
        areaManager.provinceDataSignal
            .subscribe(onNext: { [weak self] in self?.container.reloadProvince(data: $0) })
            .disposed(by: disposeBag)
        
        areaManager.cityDataSignal
            .subscribe(onNext: { [weak self] in self?.container.reloadCity(id: $0.0, data: $0.1) })
            .disposed(by: disposeBag)
        
        container.provinceClicked = { [weak self] in self?.areaManager.loadCity(id: $0.id) }
        container.cityClicked = { [weak self] in
            self?.cityClicked?($0)
            self?.excuteAnimotion()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        container.frame = view.bounds
    }
}

extension HCAreaSelectedViewController {
    
    public func excuteAnimotion() {
        container.excuteAnimotion { [weak self] in
            if $0 {
                self?.view.removeFromSuperview()
                self?.removeFromParaentViewController()
            }
        }
    }

}
