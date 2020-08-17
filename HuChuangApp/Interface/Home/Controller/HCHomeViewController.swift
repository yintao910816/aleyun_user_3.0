//
//  HCHomeViewController.swift
//  HuChuangApp
//
//  Created by sw on 2020/8/8.
//  Copyright © 2020 sw. All rights reserved.
//

import UIKit

class HCHomeViewController: BaseViewController {

    private var containerView: HCHomeViewContainer!
    
    override func setupUI() {
        containerView = HCHomeViewContainer.init(frame: .init(x: 0, y: 0, width: view.width, height: view.height))
        view.addSubview(containerView)
    }
    
    override func rxBind() {
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
//            HCHelper.presentLogin()
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.frame = view.bounds
    }
}
