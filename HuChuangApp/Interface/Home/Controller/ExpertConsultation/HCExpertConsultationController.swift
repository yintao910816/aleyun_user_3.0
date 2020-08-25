//
//  HCExpertConsultationController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/25.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCExpertConsultationController: BaseViewController {

    private var viewModel: HCExpertConsultationViewModel!
    private var containerView: HCExpertConsultationContainer!
    
    override func setupUI() {
        navigationItem.title = "专家问诊"
        
        containerView = HCExpertConsultationContainer.init(frame: view.bounds)
        view.addSubview(containerView)
        
        let t = HCAreaSelectedViewController()
        addChild(t)
        view.addSubview(t.view)
        
//        let t = HCListFilterViewController.init(mode: .sorted)
//        addChild(t)
//        view.addSubview(t.view)
    }
    
    override func rxBind() {
        viewModel = HCExpertConsultationViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
